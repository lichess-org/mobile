import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';
import 'package:material_ui/material_ui.dart';

/// The icon of each practice study, as lichess.org shows it (`ui/bits/css/practice/_icons.scss`).
///
/// The SVGs from `public/images/practice/` are converted to 256px lossless WebP in
/// `assets/images/practice/`, white on transparent so that they can be tinted.
const _studyIcons = <StudyId, String>{
  StudyId('BJy6fEDf'): 'stone-pile', // Piece Checkmates I
  StudyId('fE4k21MW'): 'pocket-bow', // Checkmate Patterns I
  StudyId('8yadFPpU'): 'sword-in-stone', // Checkmate Patterns II
  StudyId('PDkQDt6u'): 'catapult', // Checkmate Patterns III
  StudyId('96Lij7wH'): 'musket', // Checkmate Patterns IV
  StudyId('Rg2cMBZ6'): 'stone-spear', // Piece Checkmates II
  StudyId('ByhlXnmM'): 'ghost-ally', // Knight & Bishop Mate
  StudyId('9ogFv8Ac'): 'voodoo-doll', // The Pin
  StudyId('tuoBxVE5'): 'pierced-body', // The Skewer
  StudyId('Qj281y1p'): 'trident', // The Fork
  StudyId('MnsJEWnI'): 'boxing-glove-surprise', // Discovered Attacks
  StudyId('RUQASaZm'): 'rogue', // Double Check
  StudyId('o734CNqp'): 'breaking-chain', // Overloaded Pieces
  StudyId('ITWY4GN2'): 'two-shadows', // Zwischenzug
  StudyId('lyVYjhPG'): 'skeletal-hand', // X-Ray
  StudyId('9cKgYrHb'): 'cement-shoes', // Zugzwang
  StudyId('g1fxVZu9'): 'bolt-shield', // Interference
  StudyId('s5pLU7Of'): 'trojan-horse', // Greek Gift
  StudyId('kdKpaYLW'): 'divert', // Deflection
  StudyId('jOZejFWk'): 'magnet', // Attraction
  StudyId('49fDW0wP'): 'upgrade', // Underpromotion
  StudyId('0YcGiH4Y'): 'quicksand', // Desperado
  StudyId('CgjKPvxQ'): 'back-forth', // Counter Check
  StudyId('udx042D6'): 'mining', // Undermining
  StudyId('Grmtwuft'): 'detour', // Clearance
  StudyId('xebrDvFe'): 'key', // Key Squares
  StudyId('A4ujYOer'): 'push', // Opposition
  StudyId('pt20yRkT'): 'stone-tower', // 7th-Rank Rook Pawn
  StudyId('MkDViieT'): 'guarded-tower', // 7th-Rank Rook Pawn
  StudyId('pqUSUw8Y'): 'siege-tower', // Basic Rook Endgames
  StudyId('heQDnvq7'): 'locked-fortress', // Intermediate Rook Endings
  StudyId('wS23j5Tm'): 'tower-fall', // Practical Rook Endings
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
