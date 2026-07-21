import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/utils/chessboard.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class PieceSetScreen extends ConsumerStatefulWidget {
  const PieceSetScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const PieceSetScreen());
  }

  @override
  ConsumerState<PieceSetScreen> createState() => _PieceSetScreenState();
}

class _PieceSetScreenState extends ConsumerState<PieceSetScreen> {
  bool isLoading = false;

  Future<void> onChanged(PieceSet? value) async {
    if (value != null) {
      ref.read(boardPreferencesProvider.notifier).setPieceSet(value);
      setState(() {
        isLoading = true;
      });
      try {
        await precachePieceImages(value);
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
	}
	// unset 3D PieceSet
	remove3DPieceSetFromPreferences();
      }
    }
  }

// TODO: Possibly reduce repeated code while still supporting 3D  (?) 
  void handlePieceSet3D(PieceSet3D? value) async {
	  if (value != null) {
	ref.read(boardPreferencesProvider.notifier).setPieceSet3D(value);
		  setState(() {
			isLoading = true;
			});
		  try {
			  await precachePieceImages3D(value);
		  } finally {
			  if (mounted) {
				  setState(() {
						  isLoading = false;
						  });
			  }
		  }
	  }

  }

void remove3DPieceSetFromPreferences(){
	ref.read(boardPreferencesProvider.notifier).setPieceSet3D(null);
}


  List<AssetImage> getPieceImages(PieceSet set) {
    return [
      set.assets[PieceKind.whiteKing]!,
      set.assets[PieceKind.blackQueen]!,
      set.assets[PieceKind.whiteRook]!,
      set.assets[PieceKind.blackBishop]!,
      set.assets[PieceKind.whiteKnight]!,
      set.assets[PieceKind.blackPawn]!,
    ];
  }

  List<AssetImage> get3DPieceImages(PieceSet3D set) {
    return [
      set.assets[PieceKind.whiteKing]!,
      set.assets[PieceKind.blackQueen]!,
      set.assets[PieceKind.whiteRook]!,
      set.assets[PieceKind.blackBishop]!,
      set.assets[PieceKind.whiteKnight]!,
      set.assets[PieceKind.blackPawn]!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.pieceSet),
          actions: [if (isLoading) const PlatformAppBarLoadingIndicator()],
          bottom: const TabBar(
            tabs: [
              Tab(text: '2D'), // TODO: Create i18n translations for these tabs
              Tab(text: '3D'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SafeArea(
                child: ListView.separated(
                  itemCount: PieceSet.values.length,
                  separatorBuilder: (_, _) => Theme.of(context).platform == TargetPlatform.iOS
                      ? const PlatformDivider()
                      : const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final pieceSet = PieceSet.values[index];
                    return ListTile(
                      trailing: (boardPrefs.pieceSet == pieceSet && boardPrefs.pieceSet3D == null) ? const Icon(Icons.check) : null,
                      title: Text(pieceSet.label),
                      subtitle: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 264),
                        child: Stack(
                          children: [
                            BrightnessHueFilter(
                              brightness: boardPrefs.brightness,
                              hue: boardPrefs.hue,
                              child: boardPrefs.boardTheme.thumbnail,
                            ),
                            Row(
                              children: [
                                for (final img in getPieceImages(pieceSet))
                                  Image(image: img, height: 44),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: isLoading ? null : () => onChanged(pieceSet),
                      selected: boardPrefs.pieceSet == pieceSet,
                    );
                  },
                ),
              ),
            ),
            Center(
              child: SafeArea(
                child: ListView.separated(
                  itemCount: PieceSet3D.values.length,
                  separatorBuilder: (_, _) => Theme.of(context).platform == TargetPlatform.iOS
                      ? const PlatformDivider()
                      : const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final pieceSet = PieceSet3D.values[index];
                    return ListTile(
                      trailing: boardPrefs.pieceSet3D == pieceSet ? const Icon(Icons.check) : null,
                      title: Text(pieceSet.label),
                      subtitle: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 264),
                        child: Stack(
                          children: [
                            BrightnessHueFilter(
                              brightness: boardPrefs.brightness,
                              hue: boardPrefs.hue,
                              child: boardPrefs.boardTheme.thumbnail,
                            ),
                            Wrap(
                              spacing: -3,
                              children: [
                                for (final img in get3DPieceImages(pieceSet))
                                  Transform.translate(
                                    offset: const Offset(0, -9),
                                    child: Image(image: img, height: 60),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: isLoading ? null : () => handlePieceSet3D(pieceSet),
                      selected: boardPrefs.pieceSet3D == pieceSet,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
