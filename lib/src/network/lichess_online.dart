import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/server_status.dart';

/// A provider that indicates whether the lichess server is reachable.
///
/// Returns true only when both the network is available and the lichess server
/// is reachable via the WebSocket connection.
///
/// This should be used instead of [onlineStatusProvider] when checking whether
/// online features that require the lichess server are available.
///
/// Note: [onlineStatusProvider] only checks network connectivity, not whether
/// the lichess server itself is reachable. During a server outage, the network
/// may still be available but the server unreachable.
final lichessOnlineProvider = Provider.autoDispose<bool>((ref) {
  final isNetworkOnline = ref.watch(onlineStatusProvider).value ?? false;
  final isServerReachable = ref.watch(serverStatusProvider);
  return isNetworkOnline && isServerReachable;
});
