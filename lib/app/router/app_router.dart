import 'package:go_router/go_router.dart';

import '../../features/feature_select/feature_select_screen.dart';
import '../../features/operator_panel/operator_panel_screen.dart';
import '../../features/pin_input/pin_input_screen.dart';
import '../../features/photo_session/photo_session_screen.dart';
import '../../features/result/result_screen.dart';
import '../../features/review/review_screen.dart';
import '../../features/strip_select/strip_select_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import 'route_paths.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.welcome,
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
}