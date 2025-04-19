import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text('Menu', style: AppTextStyles.drawerHeader),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Clubs'),
              onTap: () => Navigator.pushReplacementNamed(context, '/clubs'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Club'),
              onTap: () => Navigator.pushReplacementNamed(context, '/clubEdit'),
            ),
            ListTile(
                leading: const Icon(Icons.exit_to_app_outlined),
                title: const Text('Log Out'),
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),


      body: Padding(
        padding: AppPaddings.all16,
        child: Column(
          children: [
            const CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage('https://image.hurimg.com/i/hurriyet/75/770x0/5943dd040f25442444482768.jpg'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Elif Durdane Koc',
              style: AppTextStyles.profileName,
            ),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text('elif.koc@sabanciuniv.edu'),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text('0 (532) 123 4567'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Instructor'),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Log out'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/aboutUs');
              },
              child: const Text('About Us'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/favorites');
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
}
