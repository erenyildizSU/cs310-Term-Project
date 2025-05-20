import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = "Loading...";
  String email = "Loading...";
  String phone = "Loading...";
  String role = "Loading...";
  String profileImageUrl = ""; // ✅ profil fotoğrafı için
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Kullanıcı verilerini Firestore'dan alma
  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists) {
          setState(() {
            name = doc['name'] ?? 'No Name';
            email = doc['email'] ?? 'No Email';
            phone = doc['phone'] ?? 'No Phone';
            role = doc['role'] ?? 'No Role';
            profileImageUrl = doc['profileImageUrl'] ?? ''; // ✅ burası önemli
            _isLoading = false;
          });
        } else {
          setState(() {
            name = 'User Not Found';
            email = 'N/A';
            phone = 'N/A';
            role = 'N/A';
            profileImageUrl = '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        name = 'Error';
        email = 'Error';
        phone = 'Error';
        role = 'Error';
        profileImageUrl = '';
        _isLoading = false;
      });
    }
  }

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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
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
            _isLoading
                ? const CircularProgressIndicator()
                : profileImageUrl.isNotEmpty
                ? CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(profileImageUrl),
            )
                : const CircleAvatar(
              radius: 75,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 75,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
              name,
              style: AppTextStyles.profileName,
            ),
            const SizedBox(height: 16),

            // Kullanıcı Bilgileri
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(role),
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