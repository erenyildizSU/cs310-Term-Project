import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'club.dart';

class ClubProfileScreen extends StatelessWidget {
  final Club club;

  const ClubProfileScreen({Key? key, required this.club}) : super(key: key);

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
                    image: AssetImage(club.logoAssetPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                club.name,
                style: AppTextStyles.profileName,
              ),
            ),
            const SizedBox(height: 8),
            Text(club.description),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(club.email),
            ),
            const SizedBox(height: 16),
            const Text('Upcoming Events', style: AppTextStyles.sectionTitle),
            Consumer<EventProvider>(
              builder: (context, eventProvider, _) {
                final clubEvents = eventProvider.getEventsByCreator(club.id);

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
