import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../utils/app_assets.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

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
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary,
            padding: AppPaddings.horizontal16,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.elifHoca),
                  radius: 25,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Welcome", style: AppTextStyles.welcome),
                    Text("Elif Dürdane Koç", style: AppTextStyles.welcomeName),
                  ],
                )
              ],
            ),
          ),

          Container(
            color: AppColors.primary,
            padding: AppPaddings.all16,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search event",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("Categories", style: AppTextStyles.sectionTitleBlack),
          ),

          Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                categoryButton("Sport", Icons.sports_soccer),
                categoryButton("Art", Icons.music_note),
                categoryButton("Career", Icons.work_outline),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("Results", style: AppTextStyles.sectionTitleBlack),
          ),

          Padding(
            padding: AppPaddings.horizontal16,
            child: GestureDetector(
              onTap: () {
                print("Etkinlik kartına tıklandı");
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppAssets.networking,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text("Networking Fair", style: AppTextStyles.resultTitle),
          ),

          const Padding(
            padding: AppPaddings.horizontal16,
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Sabancı University Tuzla Campus", style: AppTextStyles.resultLocation),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/favorites');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/userProfile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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

  static Widget categoryButton(String title, IconData icon) {
    return InkWell(
      onTap: () {
        print("$title butonuna tıklandı");
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueAccent.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.categoryTitle),
          ],
        ),
      ),
    );
  }
}
