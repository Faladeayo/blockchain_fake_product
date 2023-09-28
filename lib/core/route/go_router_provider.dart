import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:substandard_products/features/home/add_menu_page.dart';

import '../../common/error/route_error_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/dashboard/presentation/ui/dashboard_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/share/share_screen.dart';
import '../../features/splash_screen.dart';

enum AppRoute {
  splash,
  onBoarding,
  login,
  register,
  share,

  home,
  profile,
  addProduct,
}

final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider.autoDispose<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) {
          return SplashScreen(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(key: state.pageKey),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        builder: (context, state) => RegisterScreen(key: state.pageKey),
      ),
      ShellRoute(
        navigatorKey: _shellNavigator,
        builder: (context, state, child) =>
            DashboardScreen(key: state.pageKey, child: child),
        routes: [
          GoRoute(
              path: '/',
              name: AppRoute.home.name,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: HomeScreen(
                    key: state.pageKey,
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: 'addProduct',
                  name: AppRoute.addProduct.name,
                  parentNavigatorKey: rootNavigator,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: AddProductScreen(
                        key: state.pageKey,
                      ),
                    );
                  },
                )
              ]),
          GoRoute(
            path: '/share',
            name: AppRoute.share.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ShareScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
          GoRoute(
            path: '/account',
            name: AppRoute.profile.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ProfileScreen(
                  key: state.pageKey,
                ),
              );
            },
          ),
        ],
      )
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
  );
});

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  Curve? curves,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 400),
    fullscreenDialog: true,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0.75, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
      ),
      child: child,
    ),
  );
}
