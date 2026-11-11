import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/service/weights_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform_segmented_control.dart';
import 'package:material_ui/material_ui.dart';

/// The engines a game can be played against, in the order the picker presents them: Stockfish
/// first, because it is what a new game plays.
enum OpponentEngine({
  required final String name,

  /// The engine's logo, shown wherever it is named.
  required final String iconAsset,

  /// A sentence or two on what this engine is, for someone choosing between them.
  required final String description,
}) {
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
    description: 'Maia is a human-like neural network chess engine.',
  );

  static OpponentEngine of(OpponentSpec spec) => switch (spec) {
    StockfishOpponentSpec() => OpponentEngine.stockfish,
    MaiaOpponentSpec() => OpponentEngine.maia,
  };
}

/// The logo of the engine [spec] plays on.
class const OpponentIcon(final OpponentSpec spec, {final double size = 44, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Image.asset(OpponentEngine.of(spec).iconAsset, width: size, height: size);
}

/// The opponent part of a new game form: the engine (when the variant lets the user choose one),
/// what it is, and its level, followed by [children] in the same section.
///
/// Every change of opponent is reported through [onChanged], including the ones the user did not
/// make: a Maia rating whose network is no longer on the device, or could not be downloaded, is
/// swapped for the one that ships with the app, so that [selected] is always playable once no
/// download is running ([onDownloadingChanged]).
class const OpponentSettings({
  required final OpponentSpec selected,

  /// The variant the game will be played in. Maia only knows standard chess, so for anything else
  /// there is nothing to choose between.
  required final Variant variant,
  required final ValueChanged<OpponentSpec> onChanged,

  /// Called when a Maia network starts (true) or stops (false) downloading.
  required final ValueChanged<bool> onDownloadingChanged,

  /// The other settings of the game, in the section of the opponent's level.
  final List<Widget> children = const [],
  super.key,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<OpponentSettings> createState() => _OpponentSettingsState();
}

class _OpponentSettingsState() extends ConsumerState<OpponentSettings> {
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
    _level = StockfishLevel.defaultLevel;
    _rating = MaiaRating.defaultRating;
    _select(widget.selected);
    final initialRating = _rating;
    _weights.availableRatings().then((available) {
      // Nothing else ever looks at the networks an older version of the app left behind: no rating
      // claims them, so no check ever reaches them. Sweeping them here, where the Maia files are
      // the user's concern anyway, keeps a megabyte of dead weight off the device without making
      // it anyone's chore.
      unawaited(_weights.deleteUnusableWeights());
      if (!mounted) return;
      setState(() => _available = available);
      if (available.contains(_rating)) return;
      if (_rating == initialRating) {
        // The network of the preferred rating is gone, e.g. deleted after it failed its checksum:
        // fall back to the bundled one rather than download it unasked.
        _update(() => _rating = MaiaRating.defaultRating);
      } else {
        // Picked before we knew what was on the device, so nothing fetched it yet.
        _ensure(_rating);
      }
    });
  }

  @override
  void didUpdateWidget(OpponentSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The form changed the opponent itself, e.g. back to Stockfish for a variant Maia cannot play.
    if (widget.selected != _spec) setState(() => _select(widget.selected));
  }

  /// Shows [spec], keeping the level or rating of the other engine.
  void _select(OpponentSpec spec) {
    _engine = _maiaAvailable ? OpponentEngine.of(spec) : OpponentEngine.stockfish;
    switch (spec) {
      case StockfishOpponentSpec(:final level):
        _level = level;
      case MaiaOpponentSpec(:final rating):
        _rating = rating;
    }
  }

  OpponentSpec get _spec => switch (_engine) {
    OpponentEngine.stockfish => StockfishOpponentSpec(_level),
    OpponentEngine.maia => MaiaOpponentSpec(_rating),
  };

  /// Applies [change], and reports the opponent if it changed.
  void _update(VoidCallback change) {
    final before = _spec;
    setState(change);
    if (_spec != before) widget.onChanged(_spec);
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
    widget.onDownloadingChanged(true);
    final path = await _weights.download(rating);
    if (!mounted) return;

    _update(() {
      _downloading = null;
      if (path != null) {
        _available = {...?_available, rating};
      } else {
        _failed = rating;
        _rating = MaiaRating.defaultRating;
      }
    });
    widget.onDownloadingChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_maiaAvailable)
          Padding(
            padding: Styles.horizontalBodyPadding,
            child: PlatformSegmentedControl<OpponentEngine>(
              segments: [for (final engine in OpponentEngine.values) (engine, engine.name)],
              selected: _engine,
              showSelectedIcon: false,
              onChanged: (engine) => _update(() => _engine = engine),
            ),
          ),
        Padding(padding: Styles.bodySectionPadding, child: _EngineDescription(_engine)),
        ListSection(
          materialFilledCard: true,
          children: [
            switch (_engine) {
              OpponentEngine.stockfish => _StockfishLevelTile(
                level: _level,
                onChanged: (level) => _update(() => _level = level),
              ),
              OpponentEngine.maia => _MaiaRatingTile(
                rating: _rating,
                available: _available,
                downloading: _downloading,
                failed: _failed,
                onChanged: (rating) {
                  _update(() => _rating = rating);
                  _ensure(rating);
                },
              ),
            },
            ...widget.children,
          ],
        ),
      ],
    );
  }
}

class const _EngineDescription(final OpponentEngine engine) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(engine.iconAsset, width: 40, height: 40),
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

class const _StockfishLevelTile({
  required final StockfishLevel level,
  required final ValueChanged<StockfishLevel> onChanged,
}) extends StatefulWidget {
  @override
  State<_StockfishLevelTile> createState() => _StockfishLevelTileState();
}

class _StockfishLevelTileState() extends State<_StockfishLevelTile> {
  /// The level under the finger during a drag, reported only once the drag ends.
  StockfishLevel? _dragged;

  StockfishLevel get _shown => _dragged ?? widget.level;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text.rich(
        TextSpan(
          text: '${context.l10n.level}: ',
          children: [
            TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              text: '${_shown.level}',
            ),
          ],
        ),
      ),
      subtitle: NonLinearSlider(
        value: _shown.level,
        values: StockfishLevel.values.map((l) => l.level).toList(),
        onChange: (value) => setState(() => _dragged = StockfishLevel.values[value.toInt() - 1]),
        onChangeEnd: (value) {
          setState(() => _dragged = null);
          widget.onChanged(StockfishLevel.values[value.toInt() - 1]);
        },
      ),
    );
  }
}

class const _MaiaRatingTile({
  required final MaiaRating rating,
  required final Set<MaiaRating>? available,
  required final MaiaRating? downloading,
  required final MaiaRating? failed,
  required final ValueChanged<MaiaRating> onChanged,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MaiaRatingTile> createState() => _MaiaRatingTileState();
}

class _MaiaRatingTileState() extends ConsumerState<_MaiaRatingTile> {
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
class const _MaiaWeightsStatus({
  required final MaiaRating rating,
  required final Set<MaiaRating>? available,
  required final MaiaRating? downloading,
}) extends ConsumerWidget {
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
