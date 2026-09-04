import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:material_ui/material_ui.dart';

/// The engines a game can be played against, in the order the picker presents them: Stockfish
/// first, because it is what a new game plays.
enum OpponentEngine {
  stockfish(
    name: 'Stockfish',
    iconAsset: 'assets/images/stockfish/icon.webp',
    description:
        'Free, open-source, and cross-platform chess engine, trusted by grandmasters and '
        'leading chess platforms worldwide.',
  ),
  maia(
    name: 'Maia',
    iconAsset: 'assets/images/maia/icon.webp',
    description:
        'Maia is a human-like neural network chess engine. Maia Chess is an ongoing research '
        'project aiming to make a more human-friendly, useful, and fun chess AI. For more '
        'information go to maiachess.com.',
  );

  const OpponentEngine({required this.name, required this.iconAsset, required this.description});

  final String name;

  /// The engine's logo, shown wherever it is named.
  final String iconAsset;

  /// A sentence or two on what this engine is, for someone choosing between them.
  final String description;

  static OpponentEngine of(OpponentSpec spec) => switch (spec) {
    StockfishOpponentSpec() => OpponentEngine.stockfish,
    MaiaOpponentSpec() => OpponentEngine.maia,
  };
}

/// The logo of the engine [spec] plays on.
class OpponentIcon extends StatelessWidget {
  const OpponentIcon(this.spec, {this.size = 44, super.key});

  final OpponentSpec spec;
  final double size;

  @override
  Widget build(BuildContext context) =>
      Image.asset(OpponentEngine.of(spec).iconAsset, width: size, height: size);
}

/// Asks the user which computer to play, and returns the opponent they chose.
///
/// The spec it returns is always playable: a Maia rating whose network could not be downloaded is
/// swapped for the one that ships with the app rather than being handed back as a game that cannot
/// start.
Future<OpponentSpec?> showOpponentPicker(
  BuildContext context, {
  required OpponentSpec selected,
  required Variant variant,
}) {
  return showModalBottomSheet<OpponentSpec>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _OpponentPickerSheet(selected: selected, variant: variant),
  );
}

class _OpponentPickerSheet extends ConsumerStatefulWidget {
  const _OpponentPickerSheet({required this.selected, required this.variant});

  final OpponentSpec selected;

  /// The variant the game will be played in. Maia only knows standard chess, so for anything else
  /// there is nothing to choose between.
  final Variant variant;

  @override
  ConsumerState<_OpponentPickerSheet> createState() => _OpponentPickerSheetState();
}

class _OpponentPickerSheetState extends ConsumerState<_OpponentPickerSheet> {
  late OpponentEngine _engine;
  late StockfishLevel _level;
  late MaiaRating _rating;

  /// The Maia networks that are on the device, or null until we have looked.
  Set<MaiaRating>? _available;

  /// The download in progress, if any, and whether the last one failed.
  MaiaRating? _downloading;
  MaiaRating? _failed;

  bool get _maiaAvailable =>
      const MaiaOpponentSpec(MaiaRating.defaultRating).supportsVariant(widget.variant);

  MaiaWeightsService get _weights => ref.read(maiaWeightsServiceProvider);

  @override
  void initState() {
    super.initState();
    _engine = _maiaAvailable ? OpponentEngine.of(widget.selected) : OpponentEngine.stockfish;
    _level = switch (widget.selected) {
      final StockfishOpponentSpec spec => spec.level,
      MaiaOpponentSpec() => StockfishLevel.defaultLevel,
    };
    _rating = switch (widget.selected) {
      final MaiaOpponentSpec spec => spec.rating,
      StockfishOpponentSpec() => MaiaRating.defaultRating,
    };
    _weights.availableRatings().then((available) {
      if (mounted) setState(() => _available = available);
    });
  }

  /// Puts [rating]'s network on the device, if it is not there already.
  ///
  /// A download that does not work leaves the selection on the network that ships with the app:
  /// the point of the fallback is that there is always a Maia to play.
  Future<void> _ensure(MaiaRating rating) async {
    if (_available?.contains(rating) ?? true) return;

    setState(() {
      _downloading = rating;
      _failed = null;
    });
    final path = await _weights.download(rating);
    if (!mounted) return;

    setState(() {
      _downloading = null;
      if (path != null) {
        _available = {...?_available, rating};
      } else {
        _failed = rating;
        _rating = MaiaRating.defaultRating;
      }
    });
  }

  OpponentSpec get _spec => switch (_engine) {
    OpponentEngine.stockfish => StockfishOpponentSpec(_level),
    OpponentEngine.maia => MaiaOpponentSpec(_rating),
  };

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      children: [
        if (_maiaAvailable)
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: SegmentedButton<OpponentEngine>(
              segments: [
                for (final engine in OpponentEngine.values)
                  ButtonSegment(value: engine, label: Text(engine.name)),
              ],
              selected: {_engine},
              showSelectedIcon: false,
              onSelectionChanged: (selection) => setState(() => _engine = selection.first),
            ),
          ),
        Padding(padding: Styles.bodySectionPadding, child: _EngineDescription(_engine)),
        ListSection(
          materialFilledCard: true,
          children: [
            switch (_engine) {
              OpponentEngine.stockfish => _StockfishLevelTile(
                level: _level,
                onChanged: (level) => setState(() => _level = level),
              ),
              OpponentEngine.maia => _MaiaRatingTile(
                rating: _rating,
                available: _available,
                downloading: _downloading,
                failed: _failed,
                onChanged: (rating) {
                  setState(() => _rating = rating);
                  _ensure(rating);
                },
              ),
            },
          ],
        ),
        Padding(
          padding: Styles.bodySectionPadding,
          child: FilledButton(
            onPressed: _downloading != null ? null : () => Navigator.of(context).pop(_spec),
            child: Text(context.l10n.ok, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}

class _EngineDescription extends StatelessWidget {
  const _EngineDescription(this.engine);

  final OpponentEngine engine;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(engine.iconAsset, width: 56, height: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(engine.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                engine.description,
                style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StockfishLevelTile extends StatelessWidget {
  const _StockfishLevelTile({required this.level, required this.onChanged});

  final StockfishLevel level;
  final ValueChanged<StockfishLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text.rich(
        TextSpan(
          text: '${context.l10n.level}: ',
          children: [
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              text: '${level.level}',
            ),
          ],
        ),
      ),
      subtitle: NonLinearSlider(
        value: level.level,
        values: StockfishLevel.values.map((l) => l.level).toList(),
        onChange: (value) => onChanged(StockfishLevel.values[value.toInt() - 1]),
        onChangeEnd: (value) => onChanged(StockfishLevel.values[value.toInt() - 1]),
      ),
    );
  }
}

class _MaiaRatingTile extends ConsumerStatefulWidget {
  const _MaiaRatingTile({
    required this.rating,
    required this.available,
    required this.downloading,
    required this.failed,
    required this.onChanged,
  });

  final MaiaRating rating;
  final Set<MaiaRating>? available;
  final MaiaRating? downloading;
  final MaiaRating? failed;
  final ValueChanged<MaiaRating> onChanged;

  @override
  ConsumerState<_MaiaRatingTile> createState() => _MaiaRatingTileState();
}

class _MaiaRatingTileState extends ConsumerState<_MaiaRatingTile> {
  MaiaRating? _dragged;

  @override
  void didUpdateWidget(_MaiaRatingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) _dragged = null;
  }

  MaiaRating get _shown => _dragged ?? widget.rating;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text.rich(
        TextSpan(
          text: '${context.l10n.strength}: ',
          children: [
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              text: '${_shown.rating}',
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          NonLinearSlider(
            value: _shown.rating,
            values: MaiaRating.values.map((r) => r.rating).toList(),
            onChange: (value) => setState(() => _dragged = MaiaRating.fromRating(value.toInt())),
            onChangeEnd: (value) {
              setState(() => _dragged = null);
              widget.onChanged(MaiaRating.fromRating(value.toInt())!);
            },
          ),
          if (widget.failed != null)
            Text(
              'Maia ${widget.failed!.rating} could not be downloaded. Maia '
              '${MaiaRating.defaultRating.rating} will play instead.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      trailing: _MaiaWeightsStatus(
        rating: _shown,
        available: widget.available,
        downloading: widget.downloading,
      ),
    );
  }
}

/// Says whether the selected network is on the device or being fetched.
class _MaiaWeightsStatus extends ConsumerWidget {
  const _MaiaWeightsStatus({
    required this.rating,
    required this.available,
    required this.downloading,
  });

  final MaiaRating rating;
  final Set<MaiaRating>? available;
  final MaiaRating? downloading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (downloading != null) {
      return ValueListenableBuilder(
        valueListenable: ref.read(maiaWeightsServiceProvider).downloadProgress,
        builder: (context, progress, _) => SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(value: progress > 0 ? progress : null),
        ),
      );
    }

    // Until we have looked at what is on the device there is nothing truthful to show.
    if (available == null) return const SizedBox.shrink();

    if (!available!.contains(rating)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_download_outlined),
          Text(
            '${(rating.expectedSize / (1024 * 1024)).toStringAsFixed(1)} MB',
            style: TextStyle(fontSize: 12, color: textShade(context, Styles.subtitleOpacity)),
          ),
        ],
      );
    }

    return const Icon(Icons.cloud_done_outlined);
  }
}
