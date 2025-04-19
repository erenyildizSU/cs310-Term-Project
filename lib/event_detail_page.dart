import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';

class Event {
  final String name;
  final String description;
  final String posterUrl;
  final DateTime date;
  final String time;
  final String venue;

  Event({
    required this.name,
    required this.description,
    required this.posterUrl,
    required this.date,
    required this.time,
    required this.venue,
  });
}

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isFavorite = false;
  bool isAttending = false;

  void toggleFavorite() {
    setState(() => isFavorite = !isFavorite);

    if (isFavorite) {
      Navigator.pushNamed(context, '/favorites');
    }
  }

  void attendEvent() {
    setState(() => isAttending = !isAttending);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAttending
              ? '✔ You are now attending this event!'
              : '✖ You are no longer attending this event.',
        ),
        backgroundColor: isAttending ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${widget.event.date.year}-${widget.event.date.month.toString().padLeft(2, '0')}-${widget.event.date.day.toString().padLeft(2, '0')}";

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
            Image.asset(widget.event.posterUrl, fit: BoxFit.contain),
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
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.horizontal12,
              child: Text(
                widget.event.description,
                style: AppTextStyles.eventDescription,
              ),
            ),
            Padding(
              padding: AppPaddings.all12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.calendar_today), const SizedBox(width: 8), Text('Date: $formattedDate')]),
                  Row(children: [const Icon(Icons.access_time), const SizedBox(width: 8), Text('Time: ${widget.event.time}')]),
                  Row(children: [const Icon(Icons.location_on), const SizedBox(width: 8), Text('Venue: ${widget.event.venue}')]),
                ],
              ),
            ),
            Padding(
              padding: AppPaddings.all12,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: attendEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAttending
                        ? AppColors.disabled
                        : AppColors.primary,
                    padding: AppPaddings.vertical14,
                  ),
                  child: Text(
                    isAttending ? 'Attending' : 'Attend',
                    style: const TextStyle(fontSize: 18, color: AppColors.textWhite),
                  ),
                ),
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
