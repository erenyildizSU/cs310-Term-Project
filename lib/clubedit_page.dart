import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/app_paddings.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';
import 'clubevent_page.dart';

class ClubEditPage extends StatefulWidget {
  const ClubEditPage({super.key});

  @override
  State<ClubEditPage> createState() => _ClubEditPageState();
}

class _ClubEditPageState extends State<ClubEditPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String clubName = "Loading...";
  String clubLogo = "";
  String userRole = "";
  String clubId = "";
  bool isLoading = true;
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  void _showErrorDialogAndRedirect(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Hata mesajı penceresini kapat
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Ana sayfaya dön
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String fetchedRole = userDoc['role'] ?? "none";
          String fetchedClubId = userDoc['club_id'] ?? "none";

          if (fetchedRole == "president" && fetchedClubId != "none") {
            setState(() {
              userRole = fetchedRole;
              clubId = fetchedClubId;
            });
            await _fetchClubData();
            await _fetchClubEvents();
          } else {
            _showErrorDialogAndRedirect("Access Denied", "You do not have permission to edit this club.");
          }
        }
      } catch (e) {
        print("Error fetching user data: $e");
        _showErrorDialog("Error", "Failed to load user data.");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchClubData() async {
    try {
      final clubDoc = await FirebaseFirestore.instance
          .collection('club_names')
          .doc(clubId)
          .get();

      if (clubDoc.exists) {
        setState(() {
          clubName = clubDoc['club_name'] ?? "Unknown Club";
          clubLogo = clubDoc['logo'] ?? "";
          _emailController.text = clubDoc['club_mail'] ?? "No email";
          _descriptionController.text = clubDoc['description'] ?? "No description";
        });
      } else {
        _showErrorDialog("Club Not Found", "No club data found.");
      }
    } catch (e) {
      print("Error fetching club data: $e");
      _showErrorDialog("Error", "Failed to load club data.");
    }
  }

  Future<void> _fetchClubEvents() async {
    try {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events_detail')
          .where('createdBy', isEqualTo: clubId)
          .get();

      setState(() {
        events = eventsSnapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList();
      });
    } catch (e) {
      print("Error fetching events: $e");
      _showErrorDialog("Error", "Failed to load club events.");
    }
  }

  Future<void> _createNewEventNotification(String eventName) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'type': 'Event',
        'message': 'New event created: $eventName',
        'timestamp': Timestamp.now(),
        'isRead': false,
      });
    } catch (e) {
      print("Error creating notification: $e");
    }
  }

  Future<void> _createNewEvent() async {
    try {
      final newEventRef = await FirebaseFirestore.instance
          .collection('events_detail')
          .add({
        'title': 'New Event',
        'description': 'Description of the new event',
        'date': '01/01/2025',
        'time': '12:00',
        'imageUrl': '',
        'location': 'Unknown Location',
        'createdBy': clubId,
      });

      await _createNewEventNotification('Check the homepage!');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubEventPage(eventId: newEventRef.id),
        ),
      );
    } catch (e) {
      print("Error creating new event: $e");
      _showErrorDialog("Error", "Failed to create new event.");
    }
  }

  Future<void> _updateClubData() async {
    try {
      await FirebaseFirestore.instance
          .collection('club_names')
          .doc(clubId)
          .update({
        'description': _descriptionController.text,
        'club_mail': _emailController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Club data updated successfully.')),
      );
    } catch (e) {
      print("Error updating club data: $e");
      _showErrorDialog("Update Failed", "Unable to update club data.");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: event['imageUrl'] != null
            ? Image.network(event['imageUrl'], width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.event, size: 50),
        title: Text(event['title'] ?? "Unknown Event", style: AppTextStyles.clubTitle),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClubEventPage(eventId: event['id']),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Club Management Screen', style: AppTextStyles.appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: AppPaddings.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: clubLogo.isNotEmpty
                  ? NetworkImage(clubLogo)
                  : const AssetImage("assets/black_placeholder.png") as ImageProvider,
              radius: AppSizes.avatarLarge,
            ),
            const SizedBox(height: 8),
            Text(clubName, style: AppTextStyles.clubTitle),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Club Email"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateClubData,
              child: const Text('Update Club Info'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNewEvent,
              child: const Text('New Event'),
            ),
            const SizedBox(height: 20),
            const Text("Events", style: AppTextStyles.sectionTitle),
            ...events.map((event) => _buildEventCard(event)).toList(),
          ],
        ),
      ),
    );
  }
}