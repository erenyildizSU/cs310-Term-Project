import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_paddings.dart';
import '../utils/app_sizes.dart';
import '../utils/app_assets.dart';
import '../utils/app_strings.dart';
import '../utils/app_icons.dart';
import 'event_detail_page.dart';
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

  final List<Event> events = [
    Event(
      name: 'Networking Fair',
      description: 'A networking event for professionals.',
      posterUrl: AppAssets.networking,
      date: DateTime(2025, 3, 5),
      time: '10:00 - 17:00',
      venue: 'Sabanci University Tuzla Campus',
    ),
    Event(
      name: 'Karaoke Night',
      description: 'A fun karaoke night for students.',
      posterUrl: AppAssets.karaoke,
      date: DateTime(2025, 3, 10),
      time: '19:00 - 23:00',
      venue: 'Sabanci University Tuzla Campus',
    ),
    Event(
      name: 'Tech Summit',
      description: 'Technology summit with expert speakers.',
      posterUrl: AppAssets.techSummit,
      date: DateTime(2025, 3, 12),
      time: '09:00 - 17:00',
      venue: 'Sabanci University Tuzla Campus',
    ),
  ];

  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _filteredEvents = events;
    _searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEvents = events.where((event) => event.name.toLowerCase().contains(query)).toList();
    });
  }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      final club = clubs[index];
                      return Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClubProfileScreen(club: club)),
                          ),
                          child: SizedBox(
                            height: AppSizes.clubImageHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: AppPaddings.horizontal16,
                  child: Text('Recent Activities', style: AppTextStyles.sectionTitleBig),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
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
                                    image: AssetImage(event.posterUrl),
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
                ),
              ],
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
                  IconButton(
                    icon: AppIcons.search,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Find a events',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
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