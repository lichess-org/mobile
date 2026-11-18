import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:material_ui/material_ui.dart';

class const CoachPicture({required final String? url, required final double size, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pictureUrl = url;

    return SizedBox(
      width: size,
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: pictureUrl != null
              ? HttpNetworkImageWidget(
                  pictureUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.person),
                )
              : const Icon(Icons.person),
        ),
      ),
    );
  }
}
