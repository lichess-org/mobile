import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';

/// Whether the analysis screens open with the small board, a transient choice of each screen.
///
/// On tablets in portrait, the full size board makes the analysis tabs below it tiny (see
/// https://github.com/lichess-org/mobile/issues/3150). Short phone screens get a wider board margin
/// instead (`kShortScreenBoardSideMargin`).
bool isSmallBoardByDefault(BuildContext context) => isTabletOrLarger(context);

/// Whether the board size of the analysis screens can be switched: only in portrait, since in
/// landscape the board size doesn't depend on it.
bool canToggleBoardSize(BuildContext context) =>
    MediaQuery.orientationOf(context) == Orientation.portrait;

/// A bottom bar button of the analysis screens that switches between the full size board and the
/// small board, grouped with the menu button in a [BottomBarGroup].
///
/// Show it only when [canToggleBoardSize].
class const BoardSizeToggleButton({
  required final bool smallBoard,
  required final VoidCallback onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomBarButton(
      label: context.l10n.mobileSmallBoard,
      onTap: onTap,
      // Like the board navigation arrows, pointing to where the board edge moves: up to shrink the
      // full size board, down to enlarge the small one.
      icon: smallBoard ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
    );
  }
}
