import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'club.dart';

class ClubProfileScreen extends StatefulWidget {
  final Club club;

  const ClubProfileScreen({Key? key, required this.club}) : super(key: key);

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  String clubDescription = "Loading...";
  String clubEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchClubData();
  }

  Future<void> _fetchClubData() async {
    try {
      final clubDoc = await FirebaseFirestore.instance
          .collection('club_names')
          .doc(widget.club.id) // Club ID'yi kullanarak veriyi çekiyoruz.
          .get();

      if (clubDoc.exists) {
        setState(() {
          clubDescription = clubDoc['description'] ?? "No description";
          clubEmail = clubDoc['club_mail'] ?? "No email";
        });
      } else {
        setState(() {
          clubDescription = "Club data not found.";
          clubEmail = "No email available.";
        });
      }
    } catch (e) {
      print("Error fetching club data: $e");
      setState(() {
        clubDescription = "Error loading description.";
        clubEmail = "Error loading email.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Profile', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.club.logoAssetPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                widget.club.name,
                style: AppTextStyles.profileName,
              ),
            ),
            const SizedBox(height: 8),
            Text(clubDescription, style: AppTextStyles.eventDescription),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(clubEmail),
            ),
            const SizedBox(height: 16),
            const Text('Upcoming Events', style: AppTextStyles.sectionTitle),
            Consumer<EventProvider>(
              builder: (context, eventProvider, _) {
                final clubEvents = eventProvider.getEventsByCreator(widget.club.id);

                if (clubEvents.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("No events found for this club."),
                  );
                }

                return Column(
                  children: clubEvents.map((event) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: event.posterUrl.isNotEmpty
                            ? Image.network(
                          event.posterUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image_not_supported),
                        title: Text(event.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.description),
                            const SizedBox(height: 4),
                            Text('Location: ${event.venue}'),
                            Text('Date: ${event.date}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/eventDetails',
                            arguments: event,
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
                IconButton(icon: const Icon(Icons.alternate_email), onPressed: () {}),
                IconButton(icon: const Icon(Icons.play_circle_filled), onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
