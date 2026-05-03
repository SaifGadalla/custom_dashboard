import '../common.dart';

class AppRoutes {
  static const String home = '/home';
}

final routerConfig = GoRouter(
  errorPageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text('Error: ${state.error}'))),
    );
  },
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return SizedBox.shrink();
      },
    ),
  ],
);
