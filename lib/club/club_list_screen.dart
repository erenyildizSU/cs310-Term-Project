import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'club_list.dart';
import 'club_profile_screen.dart';

class ClubListScreen extends StatelessWidget {
  const ClubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clubs', style: AppTextStyles.appBarTitle),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textWhite),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: clubs.length,
          itemBuilder: (context, index) {
            final club = clubs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(club.logoAssetPath),
                ),
                title: Text(club.name),
                subtitle: Text(club.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubProfileScreen(club: club),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
