import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichess_mobile/src/model/board_editor/board_vision.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

final _logger = Logger('BoardFromImage');

/// The largest side of the picture handed to the board reader: twice what the model reads, to
/// leave the final scaling to the engine's better filter, without decoding a full camera picture.
const _maxPictureSide = 1288.0;

/// A button that sets up the board from a photo of a chessboard, taken with the camera or picked
/// from the photo library.
///
/// The model that reads the photos is kept in memory from the first photo for as long as the button
/// is mounted, so that it is loaded only once per board editor.
class const BoardFromImageButton({super.key, required final void Function(String) onPlacementRead})
    extends ConsumerWidget {
  Future<void> _readFrom(BuildContext context, BoardReader reader, ImageSource source) async {
    final XFile? picture;
    try {
      picture = await ImagePicker().pickImage(
        source: source,
        maxWidth: _maxPictureSide,
        maxHeight: _maxPictureSide,
        requestFullMetadata: false,
      );
    } catch (e, st) {
      _logger.warning('Could not get a picture:', e, st);
      return;
    }
    if (picture == null) return;
    final bytes = await picture.readAsBytes();
    if (!context.mounted) return;

    final placement = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _BoardFromImageDialog(bytes, reader),
    );
    if (placement != null) onPlacementRead(placement);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reader = ref.watch(boardReaderProvider);

    return IconButton(
      icon: const Icon(Icons.photo_camera_outlined),
      tooltip: 'Camera',
      onPressed: () => showAdaptiveActionSheet<void>(
        context: context,
        actions: [
          BottomSheetAction(
            makeLabel: (context) => const Text('Take a photo'),
            onPressed: () => _readFrom(context, reader, ImageSource.camera),
          ),
          BottomSheetAction(
            makeLabel: (context) => const Text('Choose a photo'),
            onPressed: () => _readFrom(context, reader, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

enum _Step() {
  checkingModel,
  confirmDownload,
  downloading,
  reading,
  failed,
}

/// Reads the board pictured in an image, downloading the model first if needed.
///
/// Pops with the piece placement read, or with null if cancelled.
class const _BoardFromImageDialog(final Uint8List imageBytes, final BoardReader reader)
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BoardFromImageDialog> createState() => _BoardFromImageDialogState();
}

class _BoardFromImageDialogState() extends ConsumerState<_BoardFromImageDialog> {
  _Step _step = .checkingModel;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkModel();
  }

  Future<void> _checkModel() async {
    final ready = await ref.read(boardVisionServiceProvider).isModelReady();
    if (!mounted) return;
    if (ready) {
      _read();
    } else {
      setState(() => _step = .confirmDownload);
    }
  }

  Future<void> _download() async {
    setState(() => _step = .downloading);
    final ready = await ref.read(boardVisionServiceProvider).downloadModel();
    if (!mounted) return;
    if (ready) {
      _read();
    } else {
      setState(() {
        _step = .failed;
        _error = 'Could not download the board recognition model.';
      });
    }
  }

  Future<void> _read() async {
    setState(() => _step = .reading);
    try {
      final placement = await widget.reader.readPlacement(widget.imageBytes);
      if (mounted) Navigator.of(context).pop(placement);
    } catch (e, st) {
      _logger.warning('Could not read the board:', e, st);
      if (!mounted) return;
      setState(() {
        _step = .failed;
        _error = 'Could not read the board from this picture.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(boardVisionServiceProvider);

    return AlertDialog.adaptive(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(widget.imageBytes, height: 160, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          switch (_step) {
            .checkingModel || .reading => const Column(
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 12),
                Text('Reading the board…'),
              ],
            ),
            .confirmDownload => const Text(
              'Reading a board from a picture needs a $boardVisionModelSizeMB download, once. '
              'Continue?',
            ),
            .downloading => ValueListenableBuilder<double>(
              valueListenable: service.downloadProgress,
              builder: (context, progress, _) => Column(
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 12),
                  Text('Downloading… ${(progress * 100).round()}%'),
                ],
              ),
            ),
            .failed => Text(_error ?? ''),
          },
        ],
      ),
      actions: [
        if (_step == .confirmDownload)
          PlatformDialogAction(onPressed: _download, child: const Text('Download')),
        if (_step == .confirmDownload || _step == .failed)
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_step == .failed ? context.l10n.close : context.l10n.cancel),
          ),
      ],
    );
  }
}
