import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:material_ui/material_ui.dart';

/// The icon of each practice study, as lichess.org shows it (`ui/bits/css/practice/_icons.scss`).
///
/// The SVGs from `public/images/practice/` are converted to 256px lossless WebP in
/// `assets/images/practice/`, white on transparent so that they can be tinted.
const _studyIcons = <PracticeStudyId, String>{
  PracticeStudyId('BJy6fEDf'): 'stone-pile', // Piece Checkmates I
  PracticeStudyId('fE4k21MW'): 'pocket-bow', // Checkmate Patterns I
  PracticeStudyId('8yadFPpU'): 'sword-in-stone', // Checkmate Patterns II
  PracticeStudyId('PDkQDt6u'): 'catapult', // Checkmate Patterns III
  PracticeStudyId('96Lij7wH'): 'musket', // Checkmate Patterns IV
  PracticeStudyId('Rg2cMBZ6'): 'stone-spear', // Piece Checkmates II
  PracticeStudyId('ByhlXnmM'): 'ghost-ally', // Knight & Bishop Mate
  PracticeStudyId('9ogFv8Ac'): 'voodoo-doll', // The Pin
  PracticeStudyId('tuoBxVE5'): 'pierced-body', // The Skewer
  PracticeStudyId('Qj281y1p'): 'trident', // The Fork
  PracticeStudyId('MnsJEWnI'): 'boxing-glove-surprise', // Discovered Attacks
  PracticeStudyId('RUQASaZm'): 'rogue', // Double Check
  PracticeStudyId('o734CNqp'): 'breaking-chain', // Overloaded Pieces
  PracticeStudyId('ITWY4GN2'): 'two-shadows', // Zwischenzug
  PracticeStudyId('lyVYjhPG'): 'skeletal-hand', // X-Ray
  PracticeStudyId('9cKgYrHb'): 'cement-shoes', // Zugzwang
  PracticeStudyId('g1fxVZu9'): 'bolt-shield', // Interference
  PracticeStudyId('s5pLU7Of'): 'trojan-horse', // Greek Gift
  PracticeStudyId('kdKpaYLW'): 'divert', // Deflection
  PracticeStudyId('jOZejFWk'): 'magnet', // Attraction
  PracticeStudyId('49fDW0wP'): 'upgrade', // Underpromotion
  PracticeStudyId('0YcGiH4Y'): 'quicksand', // Desperado
  PracticeStudyId('CgjKPvxQ'): 'back-forth', // Counter Check
  PracticeStudyId('udx042D6'): 'mining', // Undermining
  PracticeStudyId('Grmtwuft'): 'detour', // Clearance
  PracticeStudyId('xebrDvFe'): 'key', // Key Squares
  PracticeStudyId('A4ujYOer'): 'push', // Opposition
  PracticeStudyId('pt20yRkT'): 'stone-tower', // 7th-Rank Rook Pawn
  PracticeStudyId('MkDViieT'): 'guarded-tower', // 7th-Rank Rook Pawn
  PracticeStudyId('pqUSUw8Y'): 'siege-tower', // Basic Rook Endgames
  PracticeStudyId('heQDnvq7'): 'locked-fortress', // Intermediate Rook Endings
  PracticeStudyId('wS23j5Tm'): 'tower-fall', // Practical Rook Endings
};

/// The illustration of a practice study, tinted with the ambient icon color.
///
/// A study lichess.org added after the icons were copied falls back to a generic icon.
class const PracticeStudyIcon({required final PracticeStudy study, final double size = 32.0})
    extends StatelessWidget {
  /// The asset of [study]'s icon, or null if it has none.
  static String? assetOf(PracticeStudy study) => switch (_studyIcons[study.id]) {
    final name? => 'assets/images/practice/$name.webp',
    null => null,
  };

  @override
  Widget build(BuildContext context) {
    final asset = assetOf(study);
    if (asset == null) return Icon(Icons.school, size: size);
    return Image.asset(
      asset,
      width: size,
      height: size,
      color: IconTheme.of(context).color,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.medium,
    );
  }
}
