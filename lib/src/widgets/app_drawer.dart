import '../../common.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    return Drawer(
      backgroundColor: ColorManager.surfaceWhite,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(kLogoPath, height: 60, width: 60),
            ),
          ),
          _buildListTile(
            icon: Icons.home,
            label: 'Home',
            onTap: () {
              context.go('/home');
            },
            selected: currentPath == '/home',
          ),
          _buildListTile(
            icon: Icons.info,
            label: 'About',
            onTap: () {
              context.go('/about');
            },
            selected: currentPath == '/about',
          ),
          _buildListTile(
            icon: Icons.design_services,
            label: 'Services',
            onTap: () {
              context.go('/services');
            },
            selected: currentPath == '/services',
          ),
          _buildListTile(
            icon: Icons.article,
            label: 'Articles',
            onTap: () {
              context.go('/articles');
            },
            selected: currentPath == '/articles',
          ),
          _buildListTile(
            icon: Icons.category,
            label: 'Categories',
            onTap: () {
              context.go('/categories');
            },
            selected: currentPath == '/categories',
          ),
          _buildListTile(
            icon: Icons.file_copy,
            label: 'Files',
            onTap: () {
              context.go('/files');
            },
            selected: currentPath == '/files',
          ),
        ],
      ),
    );
  }

  _buildListTile({
    required String label,
    required VoidCallback onTap,
    EdgeInsetsGeometry? contentPadding,
    required IconData icon,
    bool selected = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          leading: Icon(icon),
          style: ListTileStyle.list,
          contentPadding: contentPadding,
          title: Text(label),
          onTap: onTap,
          selected: selected,
          selectedTileColor: ColorManager.greyNormal.withValues(alpha: 0.1),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
