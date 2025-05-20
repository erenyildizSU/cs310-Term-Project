import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class NotificationItem {
  final String id;
  final String type;
  final String message;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        _notifications = snapshot.docs.map((doc) {
          final data = doc.data();
          return NotificationItem(
            id: doc.id,
            type: data['type'] ?? 'Unknown',
            message: data['message'] ?? 'No message',
            timestamp: (data['timestamp'] as Timestamp).toDate(),
            isRead: data['isRead'] ?? false,
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  void _deleteAll() async {
    await FirebaseFirestore.instance.collection('notifications').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    setState(() => _notifications.clear());
  }

  void _markAllAsRead() async {
    for (var notification in _notifications) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.id)
          .update({'isRead': true});
    }
    setState(() => _notifications.forEach((n) => n.isRead = true));
  }

  void _markAsRead(String id) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      setState(() => _notifications[index].isRead = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Notifications', style: AppTextStyles.appBarTitleBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _deleteAll,
                  child: const Text('Delete All', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text('Mark All as Read'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final n = _notifications[index];
                return ListTile(
                  title: Text(
                    n.message,
                    style: TextStyle(
                      fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(n.type),
                  trailing: Icon(
                    Icons.circle,
                    size: 10,
                    color: n.isRead ? Colors.transparent : Colors.blue,
                  ),
                  onTap: () => _markAsRead(n.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> createNewEventNotification(String eventName) async {
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
