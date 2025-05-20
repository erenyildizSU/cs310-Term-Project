import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> clubs = [];
  final roles = ['user', 'president', 'admin'];
  String? selectedClubName;
  String? selectedClubId;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchClubs();
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        users = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> _fetchClubs() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('club_names').get();
      setState(() {
        clubs = snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['club_name'] ?? 'Unknown Club'})
            .toList();
      });
    } catch (e) {
      print("Error fetching clubs: $e");
    }
  }

  Future<void> _updateUserRole(String userId, String newRole, [String? clubName, String? clubId]) async {
    try {
      final data = {'role': newRole};
      if (newRole == 'president' && clubName != null && clubId != null) {
        data['club_name'] = clubName;
        data['club_id'] = clubId;  // ✅ Club ID de güncellendi
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role updated to $newRole')),
      );
      _fetchUsers();
    } catch (e) {
      print("Error updating role: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Admin Panel', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            color: const Color(0xFF1E3A8A),
            child: ListTile(
              title: Text(
                user['email'] ?? 'Unknown Email',
                style: AppTextStyles.eventTitle.copyWith(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Role: ${user['role'] ?? 'user'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (user['role'] == 'president')
                    Text(
                      'Club Name: ${user['club_name'] ?? 'None'}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
              trailing: Column(
                children: [
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E3A8A),
                    value: user['role'] ?? 'user',
                    items: roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(
                          role,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (newRole) async {
                      if (newRole != null) {
                        if (newRole == 'president') {
                          final selectedClub = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Select Club'),
                                content: DropdownButton<String>(
                                  value: selectedClubName,
                                  items: clubs.map((club) {
                                    return DropdownMenuItem<String>(
                                      value: club['id'],  // Club ID seçilecek
                                      child: Text(club['name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    final club = clubs.firstWhere((c) => c['id'] == value);
                                    setState(() {
                                      selectedClubName = club['name'];
                                      selectedClubId = club['id'];
                                    });
                                    Navigator.pop(context, value);
                                  },
                                ),
                              );
                            },
                          );
                          if (selectedClub != null) {
                            _updateUserRole(user['id'], newRole, selectedClubName, selectedClubId);
                          }
                        } else {
                          _updateUserRole(user['id'], newRole);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
