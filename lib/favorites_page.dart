import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import '../utils/app_paddings.dart';
import '../utils/app_text_styles.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final allEvents = Provider.of<EventProvider>(context).events;
    final favoriteEvents = allEvents.where((event) => event.favorites.contains(userId)).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.favoriteGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: AppPaddings.all16,
                child: Text('FAVORITES', style: AppTextStyles.sectionTitleBigWhite),
              ),
              Expanded(
                child: favoriteEvents.isEmpty
                    ? const Center(
                  child: Text('No favorite events yet',
                      style: TextStyle(color: Colors.white70)),
                )
                    : ListView.builder(
                  padding: AppPaddings.horizontal16,
                  itemCount: favoriteEvents.length,
                  itemBuilder: (context, index) {
                    final event = favoriteEvents[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: event.posterUrl.isNotEmpty
                                ? Image.network(
                              event.posterUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.name, style: AppTextStyles.eventListTitle),
                                Text(event.date, style: AppTextStyles.eventListSubtitle),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () async {
                              await Provider.of<EventProvider>(context, listen: false)
                                  .toggleFavorite(event.id, userId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 2) Navigator.pushNamed(context, '/userProfile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
