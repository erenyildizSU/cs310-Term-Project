import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../utils/app_sizes.dart';
import '../utils/app_assets.dart';
import '../utils/app_strings.dart';
import '../utils/app_icons.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import 'club/club.dart';
import 'club/club_list.dart';
import 'club/club_profile_screen.dart';

class CampusVibeHomePage extends StatefulWidget {
  const CampusVibeHomePage({super.key});

  @override
  State<CampusVibeHomePage> createState() => _CampusVibeHomePageState();
}

class _CampusVibeHomePageState extends State<CampusVibeHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(AppStrings.drawerMenuTitle, style: AppTextStyles.drawerHeader),
            ),
            _drawerItem(Icons.person, AppStrings.drawerUserProfile, '/userProfile', context),
            _drawerItem(Icons.music_note, AppStrings.drawerClubs, '/clubs', context),
            _drawerItem(Icons.notifications, AppStrings.drawerNotifications, '/notifications', context),
            _drawerItem(Icons.comment, AppStrings.drawerComments, '/comments', context),
            _drawerItem(Icons.edit, AppStrings.drawerEditClub, '/clubEdit', context),
            _drawerItem(Icons.admin_panel_settings, 'Admin Panel', '/adminPanel', context),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.homepageBackground)),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Image.network(
              'https://live.staticflickr.com/65535/48131860942_3d8415d96a_b.jpg',
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: AppPaddings.horizontal16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: AppIcons.menu,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const Text('CampusVibe', style: AppTextStyles.logoTitle),
                  IconButton(
                    icon: AppIcons.notification,
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  IconButton(icon: AppIcons.search, onPressed: () {}),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Find an event',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: AppPaddings.horizontal16,
                  child: Text('Choose your club', style: AppTextStyles.sectionTitle),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: AppSizes.clubRowHeight,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: clubs.length,
                    itemBuilder: (context, index) {
                      final club = clubs[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClubProfileScreen(club: club)),
                        ),
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: AppSizes.avatarRadius,
                                backgroundImage: AssetImage(club.logoAssetPath),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: AppSizes.clubNameBoxHeight,
                                width: AppSizes.clubNameBoxWidth,
                                child: Center(
                                  child: Text(
                                    club.name,
                                    style: AppTextStyles.clubName,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: AppPaddings.horizontal16,
                  child: Text('Recent Activities', style: AppTextStyles.sectionTitleBig),
                ),
                const SizedBox(height: 10),
                Consumer<EventProvider>(
                  builder: (context, provider, _) {
                    final filtered = _searchController.text.isEmpty
                        ? provider.events
                        : provider.events.where((event) => event.name.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

                    return SizedBox(
                      height: 240,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final event = filtered[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/eventDetails', arguments: event);
                            },
                            child: Container(
                              width: AppSizes.cardWidth,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: AppSizes.cardHeight,
                                    width: AppSizes.cardWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      image: DecorationImage(
                                        image: event.posterUrl.isNotEmpty
                                            ? NetworkImage(event.posterUrl)
                                            : const AssetImage('assets/placeholder.png') as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(event.name, style: AppTextStyles.eventTitle),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            AppIcons.location,
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                event.venue,
                                                style: AppTextStyles.eventVenue,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.primary,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/favorites');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/userProfile');
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, String route, BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}