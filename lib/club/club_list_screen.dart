import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'club_list.dart';
import 'club_profile_screen.dart';

class ClubListScreen extends StatefulWidget {
  const ClubListScreen({super.key});

  @override
  State<ClubListScreen> createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {
  Map<String, String> clubEmails = {};

  @override
  void initState() {
    super.initState();
    _fetchClubData();
  }

  Future<void> _fetchClubData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('club_names').get();
      setState(() {
        clubEmails = {
          for (var doc in snapshot.docs)
            doc.id: doc['club_mail'] ?? 'No email'
        };
      });
    } catch (e) {
      print("Error fetching club emails: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          final email = clubEmails[club.id] ?? 'Loading...';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(club.logoAssetPath),
              ),
              title: Text(club.name),
              subtitle: Text(email),
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
    );
  }
}
