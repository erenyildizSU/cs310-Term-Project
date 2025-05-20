import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClubEventPage extends StatefulWidget {
  final String eventId;

  const ClubEventPage({super.key, required this.eventId});

  @override
  State<ClubEventPage> createState() => _ClubEventPageState();
}

class _ClubEventPageState extends State<ClubEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String clubId = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchEventData();
  }

  // 🔄 Kullanıcının kulüp ID'sini çekme
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            clubId = userDoc['club_id'] ?? "unknown";
          });
          print("User club ID: $clubId");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // 📥 Etkinlik verilerini çekme
  Future<void> _fetchEventData() async {
    try {
      final eventDoc = await FirebaseFirestore.instance
          .collection('events_detail')
          .doc(widget.eventId)
          .get();

      if (eventDoc.exists) {
        setState(() {
          _titleController.text = eventDoc['title'] ?? "Unknown Event";
          _descriptionController.text = eventDoc['description'] ?? "No description";
          _dateController.text = eventDoc['date'] ?? "Unknown Date";
          _timeController.text = eventDoc['time'] ?? "Unknown Time";
          _locationController.text = eventDoc['location'] ?? "Unknown Location";
          _imageUrlController.text = eventDoc['imageUrl'] ?? "";
          isLoading = false;
        });
      } else {
        _showErrorDialog("Event Not Found", "No event data found.");
      }
    } catch (e) {
      print("Error fetching event data: $e");
      _showErrorDialog("Error", "Failed to load event data.");
    }
  }


  Future<void> _createOrUpdateEventData() async {
    try {
      final eventRef = FirebaseFirestore.instance
          .collection('events_detail')
          .doc(widget.eventId);

      final eventData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'location': _locationController.text,
        'imageUrl': _imageUrlController.text,
        'createdBy': clubId,
        'createdAt': Timestamp.now(),
        'attendees': [],
        'favorites': [],
      };

      await eventRef.set(eventData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created/updated successfully.')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print("Error updating event data: $e");
      _showErrorDialog("Update Failed", "Unable to update event data.");
    }
  }


  Future<void> _deleteEvent() async {
    try {
      await FirebaseFirestore.instance
          .collection('events_detail')
          .doc(widget.eventId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully.')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print("Error deleting event: $e");
      _showErrorDialog("Delete Failed", "Unable to delete event.");
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Event",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imageUrlController.text.isNotEmpty)
                Image.network(
                  _imageUrlController.text,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                const Icon(Icons.image, size: 150, color: Colors.grey),
              const SizedBox(height: 20),
              _buildTextField(_titleController, "Event Title"),
              _buildTextField(_descriptionController, "Description", maxLines: 3),
              _buildTextField(_dateController, "Date"),
              _buildTextField(_timeController, "Time"),
              _buildTextField(_locationController, "Location"),
              _buildTextField(_imageUrlController, "Image URL"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createOrUpdateEventData,
                child: const Text("Update Event"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _deleteEvent,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }
}
