import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_paddings.dart';
import '../utils/app_text_styles.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, String>> favorites = [

    {'title': 'Networking Fair', 'date': '5 March Tuesday', 'image': 'assets/networking_fair.jpg'},
    {'title': 'Karaoke Night', 'date': '10 March Sunday', 'image': 'assets/karaoke_night.png'},
    {'title': 'Case-Study', 'date': '11 March Monday', 'image': 'assets/case_study.avif'},
    {'title': 'Tech Summit', 'date': '12 March Wednesday', 'image': 'assets/tech_summit.png'},
    {'title': 'The Titanic (Movie Night)', 'date': '14 March Friday', 'image': 'assets/titanic.jpg'},
    {'title': 'Painting Workshop', 'date': '17 March Monday', 'image': 'assets/painting_workshop.png'},
    {'title': 'Fashion Talks', 'date': '18 March Tuesday', 'image': 'assets/fashion_talks.png'},
    {'title': 'Everest Hiking', 'date': '7 April Monday', 'image': 'assets/everest_hiking.jpg'},

  ];

  @override
  Widget build(BuildContext context) {
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
                child: favorites.isEmpty
                    ? const Center(child: Text('No favorite events yet', style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                  padding: AppPaddings.horizontal16,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];
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
                            child: Image.asset(
                              item['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title']!, style: AppTextStyles.eventListTitle),
                                Text(item['date']!, style: AppTextStyles.eventListSubtitle),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                favorites.removeAt(index);
                              });
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
