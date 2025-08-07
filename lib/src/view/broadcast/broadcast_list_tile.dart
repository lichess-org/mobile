import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

const _kDefaultBroadcastImage = AssetImage('assets/images/broadcast_image.png');
const _kHandsetThumbnailSize = 80.0;
const _kTabletThumbnailSize = 250.0;

class BroadcastListTile extends StatelessWidget {
  const BroadcastListTile({required this.broadcast, this.maxSubtitleLines = 4})
    : _isLoading = false;

  const BroadcastListTile.loading({this.maxSubtitleLines = 4})
    : broadcast = const Broadcast(
        tour: BroadcastTournamentData(
          id: BroadcastTournamentId(''),
          name: '',
          slug: '',
          imageUrl: null,
          description: '',
          information: (
            format: null,
            timeControl: null,
            players: null,
            website: null,
            location: null,
            dates: null,
            standings: null,
          ),
        ),
        round: BroadcastRound(
          id: BroadcastRoundId(''),
          name: '',
          slug: '',
          status: RoundStatus.finished,
          startsAt: null,
          finishedAt: null,
          startsAfterPrevious: false,
        ),
        group: null,
        roundToLinkId: BroadcastRoundId(''),
      ),
      _isLoading = true;

  final Broadcast broadcast;
  final int maxSubtitleLines;

  final bool _isLoading;

  static double thumbnailSize(BuildContext context) {
    return isTabletOrLarger(context) ? _kTabletThumbnailSize : _kHandsetThumbnailSize;
  }

  static const _kPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  @override
  Widget build(BuildContext context) {
    final thumbnailSize = BroadcastListTile.thumbnailSize(context);

    if (_isLoading) {
      return Padding(
        padding: _kPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: thumbnailSize,
              height: thumbnailSize / 2,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: double.infinity,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: double.infinity,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: double.infinity,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // trailing,
          ],
        ),
      );
    }

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    final leading = broadcast.tour.imageUrl != null
        ? Image.network(
            broadcast.tour.imageUrl!,
            width: thumbnailSize,
            cacheWidth: (thumbnailSize * devicePixelRatio).toInt(),
            fit: BoxFit.cover,
            errorBuilder: (context, _, _) => const Icon(LichessIcons.radio_tower_lichess),
          )
        : Image(image: _kDefaultBroadcastImage, width: thumbnailSize);

    final title = Text(broadcast.title, maxLines: 2, overflow: TextOverflow.ellipsis);

    final subtitle = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: broadcast.round.name),
          if (broadcast.tour.information.players != null)
            TextSpan(
              text: '\n${broadcast.tour.information.players}',
              style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            ),
        ],
      ),
      maxLines: maxSubtitleLines,
      overflow: TextOverflow.ellipsis,
    );

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(BroadcastRoundScreen.buildRoute(context, broadcast));
      },
      child: Padding(
        padding: _kPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (broadcast.isLive)
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: context.lichessColors.error,
                        fontSize: 16,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (broadcast.round.startsAt != null)
                    Text(
                      relativeDate(context.l10n, broadcast.round.startsAt!).toUpperCase(),
                      style: TextStyle(
                        color: textShade(context, 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        height: 1,
                      ),
                    ),
                  const SizedBox(height: 4.0),
                  DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    child: title,
                  ),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 10),
            // trailing,
          ],
        ),
      ),
    );
  }
}

class BroadcastNextPageTile extends StatefulWidget {
  const BroadcastNextPageTile(this.nextPageFunction);

  final Future<void> Function() nextPageFunction;

  @override
  State<BroadcastNextPageTile> createState() => _BroadcastNextPageTileState();
}

class _BroadcastNextPageTileState extends State<BroadcastNextPageTile> {
  late Future<void> nextPageFuture;

  @override
  void initState() {
    super.initState();
    nextPageFuture = widget.nextPageFunction();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            debugPrint(
              'SEVERE: [BroadcastNextPageTile] could not load next page; ${snapshot.error}',
            );
          }
          return const Padding(
            padding: Styles.verticalBodyPadding,
            child: Center(child: Text('Could not load the next broadcasts')),
          );
        }

        return const Shimmer(
          child: ShimmerLoading(isLoading: true, child: BroadcastListTile.loading()),
        );
      },
    );
  }
}
