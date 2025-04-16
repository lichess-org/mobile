import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:popover/popover.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

const threeBounceLoadingIndicator = SpinKitThreeBounce(color: Colors.grey, size: 15);

/// A widget that shows the lag rating of the current socket connection.
///
/// If [socketUri] is provided, it will be used to get the lag rating from that socket route only,
/// otherwise it will use the default socket route.
class SocketPingRating extends ConsumerWidget {
  const SocketPingRating({this.socketUri, super.key});

  final Uri? socketUri;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ping = ref.watch(socketPingProvider(route: socketUri));

    return SemanticIconButton(
      semanticsLabel: 'PING: ${ping.averageLag.inMilliseconds}ms',
      icon: LagIndicator(lagRating: ping.rating, size: 24.0, showLoadingIndicator: true),
      onPressed: () {
        showPopover(
          context: context,
          bodyBuilder: (_) {
            return Consumer(
              builder: (_, ref, _) {
                final p = ref.watch(socketPingProvider(route: socketUri));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'PING: ',
                      children: [
                        TextSpan(
                          text:
                              p.averageLag > Duration.zero ? '${p.averageLag.inMilliseconds}' : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ms',
                          style: TextStyle(color: ColorScheme.of(context).onSurface),
                        ),
                      ],
                    ),
                    style: TextStyle(color: ColorScheme.of(context).onSurface),
                  ),
                );
              },
            );
          },
          backgroundColor:
              DialogTheme.of(context).backgroundColor ??
              ColorScheme.of(context).surfaceContainerHigh,
          transitionDuration: Duration.zero,
          popoverTransitionBuilder: (_, child) => child,
        );
      },
    );
  }
}

/// An indicator that shows the lag rating of the connection.
class LagIndicator extends StatelessWidget {
  const LagIndicator({
    required this.lagRating,
    this.size = 20.0,
    this.showLoadingIndicator = false,
    super.key,
  }) : assert(lagRating >= 0 && lagRating <= 4);

  /// The lag rating from 0 to 4.
  final int lagRating;

  /// Visual size of the indicator.
  final double size;

  /// Whether to show a loading indicator when the lag rating is 0.
  final bool showLoadingIndicator;

  static const spinKit = SpinKitThreeBounce(color: Colors.grey, size: 15);

  static const materialLevels = {0: Colors.red, 1: Colors.yellow, 2: Colors.green, 3: Colors.green};

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          SignalStrengthIndicator.bars(
            barCount: 4,
            minValue: 1,
            maxValue: 4,
            value: lagRating,
            size: size,
            inactiveColor: Colors.grey.withValues(alpha: 0.2),
            levels: materialLevels,
          ),
          if (showLoadingIndicator && lagRating == 0) spinKit,
        ],
      ),
    );
  }
}

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityChangesProvider);
    final theme = Theme.of(context);
    return connectivity.when(
      data: (data) {
        if (data.isOnline) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 45,
          color: theme.colorScheme.surfaceContainer,
          child: Padding(
            padding: Styles.horizontalBodyPadding,
            child: Row(
              children: [
                const Icon(Icons.report),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Network connectivity unavailable.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

/// A adaptive circular progress indicator which size is constrained so it can fit
/// in buttons.
class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}

/// A centered circular progress indicator
class CenterLoadingIndicator extends StatelessWidget {
  const CenterLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

/// A screen with an error message and a retry button.
///
/// This widget is intended to be used when a request fails and the user can
/// retry it.
class FullScreenRetryRequest extends StatelessWidget {
  const FullScreenRetryRequest({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n.mobileSomethingWentWrong, style: Styles.sectionTitle),
          const SizedBox(height: 10),
          SecondaryButton(
            onPressed: onRetry,
            semanticsLabel: context.l10n.retry,
            child: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

enum SnackBarType { error, info, success }

/// Shows a snackbar with the given message.
void showSnackBar(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: type == SnackBarType.error ? const TextStyle(color: Colors.white) : null,
      ),
      backgroundColor: type == SnackBarType.error ? context.lichessColors.error : null,
    ),
  );
}
