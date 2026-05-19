import 'package:custom_dashboard/src/pages/about/view.dart';
import 'package:custom_dashboard/src/pages/categories/view.dart';
import 'package:custom_dashboard/src/pages/files/view.dart';

import 'pages/app_shell/view.dart';
import 'pages/home/view.dart';
import 'pages/services/view.dart';
import '../common.dart';
import 'pages/articles/view.dart';
import 'pages/auth/view.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String home = 'home';
  static const String about = 'about';
  static const String articles = 'articles';
  static const String services = 'services';
  static const String files = 'files';
  static const String auth = 'auth';
  static const String categories = 'categories';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.read(authServiceProvider);

  return GoRouter(
    redirect: (context, state) {
      final isAuthenticated = authService.currentUser != null;
      final isAuthRoute = state.uri.path == '/auth';

      if (!isAuthenticated && !isAuthRoute) {
        return '/auth';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(body: Center(child: Text('Error: ${state.error}'))),
      );
    },
    routes: [
      // auth route
      GoRoute(
        path: '/auth',
        name: AppRoutes.auth,
        builder: (context, state) => const AuthView(),
      ),

      // app shell route
      ShellRoute(
        navigatorKey: appShellNavigatorKey,
        builder: (context, state, child) => AppShellView(child: child),
        routes: [
          // initial route
          GoRoute(
            path: '/',
            name: AppRoutes.initialRoute,
            redirect: (context, state) {
              if (state.uri.path == '/') {
                return state.namedLocation(
                  AppRoutes.home,
                  queryParameters: state.uri.queryParameters,
                );
              }
              return null;
            },
          ),

          // app main pages routes
          GoRoute(
            path: '/home',
            name: AppRoutes.home,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/about',
            name: AppRoutes.about,
            builder: (context, state) => AboutPage(),
          ),
          GoRoute(
            path: '/services',
            name: AppRoutes.services,
            builder: (context, state) => const ServicesPage(),
          ),
          GoRoute(
            path: '/files',
            name: AppRoutes.files,
            builder: (context, state) => const FilesPage(),
          ),
          GoRoute(
            path: '/articles',
            name: AppRoutes.articles,
            builder: (context, state) => const ArticlesPage(),
          ),
          GoRoute(
            path: '/categories',
            name: AppRoutes.categories,
            builder: (context, state) => const CategoriesPage(),
          ),
        ],
      ),
    ],
  );
});
