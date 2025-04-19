import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String date;
  final String location;

  const EventCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            SizedBox(height: 4),
            Text('Location: $location'),
            Text('Date: $date'),
          ],
        ),
      ),
    );
  }
}
