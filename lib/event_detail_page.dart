import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isFavorite = false;
  bool isAttending = false;
  int favoriteCount = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    isFavorite = widget.event.favorites.contains(userId);
    isAttending = widget.event.attendees.contains(userId);
    favoriteCount = widget.event.favorites.length;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void toggleFavorite() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await Provider.of<EventProvider>(context, listen: false)
        .toggleFavorite(widget.event.id, userId);

    setState(() {
      isFavorite = !isFavorite;
      favoriteCount += isFavorite ? 1 : -1;
    });
  }

  void toggleAttend() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await Provider.of<EventProvider>(context, listen: false)
        .toggleAttend(widget.event.id, userId);

    setState(() => isAttending = !isAttending);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAttending
              ? 'You are now attending this event!'
              : 'You are no longer attending this event.',
        ),
        backgroundColor: isAttending ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitComment() async {
    final commentText = _commentController.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (commentText.isEmpty || userId == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final userName = userDoc.data()?['name'] ?? 'Anonymous';

    await FirebaseFirestore.instance
        .collection('events_detail')
        .doc(widget.event.id)
        .collection('comments')
        .add({
      'commentText': commentText,
      'userId': userId,
      'name': userName,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    try {
      final parsedDate = DateFormat("dd.MM.yyyy").parse(widget.event.date);
      formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    } catch (_) {
      formattedDate = widget.event.date;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Event Details', style: AppTextStyles.appBarTitle),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.event.posterUrl.isNotEmpty
                ? Image.network(widget.event.posterUrl, fit: BoxFit.cover)
                : const SizedBox(
              height: 200,
              child: Center(child: Icon(Icons.image_not_supported)),
            ),
            Padding(
              padding: AppPaddings.all12,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.event.name,
                      style: AppTextStyles.eventName,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: toggleFavorite,
                      ),
                      Text(
                        '$favoriteCount',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.horizontal12,
              child: Text(widget.event.description, style: AppTextStyles.eventDescription),
            ),
            Padding(
              padding: AppPaddings.all12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 8), Text('Date: $formattedDate')]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.access_time), const SizedBox(width: 8), Text('Time: ${widget.event.time}')]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Venue: ${widget.event.venue}')),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.all12,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: toggleAttend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAttending ? AppColors.disabled : AppColors.primary,
                    padding: AppPaddings.vertical14,
                  ),
                  child: Text(
                    isAttending ? 'Attending' : 'Attend',
                    style: const TextStyle(fontSize: 18, color: AppColors.textWhite),
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: AppPaddings.all12,
              child: Text('Comments', style: AppTextStyles.eventName),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events_detail')
                  .doc(widget.event.id)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data?.docs ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index].data() as Map<String, dynamic>;
                    final text = data['commentText'] ?? '';
                    final userId = data['userId'] ?? '';
                    final name = data['name'] ?? 'Anonymous';
                    final timestamp = data['createdAt'] as Timestamp?;
                    final time = timestamp != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
                        : '';
                    final currentUser = FirebaseAuth.instance.currentUser;

                    return ListTile(
                      leading: const Icon(Icons.comment),
                      title: Text(text),
                      subtitle: Text('$name • $time'),
                      trailing: userId == currentUser?.uid
                          ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final commentId = comments[index].id;
                          await FirebaseFirestore.instance
                              .collection('events_detail')
                              .doc(widget.event.id)
                              .collection('comments')
                              .doc(commentId)
                              .delete();
                        },
                      )
                          : null,
                    );
                  },
                );
              },
            ),
            Padding(
              padding: AppPaddings.all12,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitComment,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/favorites');
          if (index == 2) Navigator.pushNamed(context, '/userProfile');
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