import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/congregations/presentation/pages/congregations_page.dart';
import '../../features/congregations/presentation/pages/congregation_details_page.dart';
import '../../features/congregations/domain/entities/congregation_entity.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/setup_page.dart';
import '../../features/routes/presentation/pages/routes_page.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.setup,
        name: 'setup',
        builder: (context, state) => const SetupPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.routes,
        name: 'routes',
        builder: (context, state) => const RoutesPage(),
      ),
      GoRoute(
          path: RouteNames.congregations,
          name: 'congregations',
          builder: (context, state) => const CongregationsPage(),
          routes: [
            GoRoute(
              path: 'details/:id',
              name: 'congregation_details',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final congregation =
                    extra?['congregation'] as CongregationEntity;

                return CongregationDetailsPage(
                  congregation: congregation,
                );
              },
            )
          ]),
    ],
  );
});
