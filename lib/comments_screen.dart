import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';

class Comment {
  final String id;
  final String username;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.username,
    required this.text,
    required this.timestamp,
  });
}

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final List<Comment> _comments = [
    Comment(id: '1', username: 'User One', text: 'First comment!', timestamp: DateTime.now().subtract(const Duration(days: 1))),
    Comment(id: '2', username: 'User Two', text: 'Second comment!', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
    Comment(id: '3', username: 'User Three', text: 'Third comment!', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
  ];

  void _removeComment(String id) {
    setState(() {
      _comments.removeWhere((c) => c.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text('Comments', style: AppTextStyles.appBarTitleBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: _comments.isEmpty
          ? const Center(child: Text('No comments yet'))
          : ListView.separated(
        padding: AppPaddings.all16,
        itemCount: _comments.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final c = _comments[index];
          return Card(
            child: Padding(
              padding: AppPaddings.all16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 8),
                      Text(c.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeComment(c.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(c.text),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }
}