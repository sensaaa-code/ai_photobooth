import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/feature_select/feature_select_screen.dart';
import '../../features/operator_panel/operator_panel_screen.dart';
import '../../features/pin_input/pin_input_screen.dart';
import '../../features/photo_session/photo_session_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/strip_select/strip_select_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../session/session_controller.dart';
import '../../session/session_state.dart';
import 'route_paths.dart';

/// Riverpod provider that exposes the app's [GoRouter] instance.
///
/// Using a provider (instead of a plain static field) allows the router to
/// react to session-state changes via [ref.listen], triggering redirect
/// re-evaluation automatically when a session expires.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.welcome,

    // --- Redirect guard ---------------------------------------------------
    // Runs every time the router evaluates a navigation (including refreshes).
    // Operator Panel is always accessible so operators can intervene.
    // Welcome is always accessible as the "safe home" screen.
    // Any other route is blocked when the session has expired.
    redirect: (context, state) {
      final session = ref.read(sessionControllerProvider);
      final isExpired = session.status == SessionStatus.expired;
      final path = state.matchedLocation;

      // These two routes are always reachable regardless of session status.
      if (path == RoutePaths.welcome) return null;
      if (path == RoutePaths.operatorPanel) return null;

      // Block access to all other routes while the session is expired.
      if (isExpired) return RoutePaths.welcome;

      return null; // allow navigation
    },

    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.pin,
        builder: (context, state) => const PinInputScreen(),
      ),
      GoRoute(
        path: RoutePaths.featureSelect,
        builder: (context, state) => const FeatureSelectScreen(),
      ),
      GoRoute(
        path: RoutePaths.photoSession,
        builder: (context, state) => const PhotoSessionScreen(),
      ),
      GoRoute(
        path: RoutePaths.review,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: RoutePaths.stripSelect,
        builder: (context, state) => const StripSelectScreen(),
      ),
      GoRoute(
        path: RoutePaths.result,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: RoutePaths.operatorPanel,
        builder: (context, state) => const OperatorPanelScreen(),
      ),
    ],
  );

  // Watch session state; whenever it changes, ask go_router to re-run
  // the redirect function above. This is what causes automatic redirection
  // to Welcome when a session expires mid-flow.
  ref.listen(sessionControllerProvider, (_, __) => router.refresh());

  // Dispose router when provider is cleaned up (e.g. hot-restart).
  ref.onDispose(router.dispose);

  return router;
});