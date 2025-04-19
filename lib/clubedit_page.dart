import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_assets.dart';
import '../utils/app_paddings.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';

class ClubEditPage extends StatelessWidget {
  const ClubEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text('Menu', style: AppTextStyles.drawerHeader),
            ),
            _drawerItem(Icons.person, 'User Profile', '/userProfile', context),
            _drawerItem(Icons.notifications, 'Notifications', '/notifications', context),
            _drawerItem(Icons.comment, 'Comments', '/comments', context),
            _drawerItem(Icons.edit, 'Edit Club', '/clubEdit', context),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('  Club Management Screen', style: AppTextStyles.appBarTitle),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          else if (index == 1) Navigator.pushNamed(context, '/favorites');
          else if (index == 2) Navigator.pushNamed(context, '/userProfile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.all16,
        child: Column(
          children: [
            Column(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.muzikusLogo),
                  radius: AppSizes.avatarLarge,
                ),
                const SizedBox(height: 8),
                const Text("MUZİKUS", style: AppTextStyles.clubTitle),
                const SizedBox(height: 8),
                const Text("Edit description"),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter club description...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.email, color: AppColors.deepBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: AppPaddings.vertical14 + AppPaddings.horizontal12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("muzikus@sabanciuniv.edu"),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => debugPrint("E-mail edit tıklandı"),
                  child: const Text("Edit"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Club Events", style: AppTextStyles.sectionTitle),
            ),
            const SizedBox(height: 12),
            eventCard(AppAssets.pajamas, "Edit Event"),
            eventCard(AppAssets.winterTown, "Edit Event"),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Social Media Accounts", style: AppTextStyles.sectionTitle),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                socialIconButton(icon: Icons.camera_alt, label: "Edit", onTap: () => debugPrint("Instagram edit tıklandı")),
                socialIconButton(icon: Icons.clear, label: "Edit", onTap: () => debugPrint("X edit tıklandı")),
                socialIconButton(icon: Icons.play_circle_fill, label: "Edit", onTap: () => debugPrint("YouTube edit tıklandı")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, String route, BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }

  Widget eventCard(String imagePath, String buttonText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => debugPrint("$buttonText tıklandı"),
            child: Text(buttonText),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget socialIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.deepBlue,
            radius: 24,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
