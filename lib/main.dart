import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'homepage.dart';
import 'user_profile.dart';
import 'comments_screen.dart';
import 'notifications_screen.dart';
import 'about_us_screen.dart';
import 'favorites_page.dart';
import 'results_page.dart';
import 'clubedit_page.dart';
import 'event_detail_page.dart';
import 'club/club_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusVibe',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => CampusVibeHomePage(),
        '/userProfile': (context) => const UserProfileScreen(),
        '/comments': (context) => const CommentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/favorites': (context) => const FavoritesPage(),
        '/results': (context) => const ResultsPage(),
        '/clubEdit': (context) => const ClubEditPage(),
        '/clubs': (context) => const ClubListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/eventDetails') {
          final event = settings.arguments as Event;
          return MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          );
        }

        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("Page not found")),
          ),
        );
      },
    );
  }
}
