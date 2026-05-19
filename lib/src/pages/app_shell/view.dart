import '../../../common.dart';

class AppShellView extends StatelessWidget {
  const AppShellView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = getValueForScreenType(
      context: context,
      mobile: true,
      tablet: false,
      desktop: false,
    );
    return Scaffold(
      body: Row(
        children: [
          if (!isMobile) AppDrawer(),
          Expanded(child: child),
        ],
      ),
      drawer: isMobile ? AppDrawer() : null,
    );
  }
}
