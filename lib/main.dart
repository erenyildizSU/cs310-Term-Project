import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'providers/theme_provider.dart';

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
import 'models/event.dart';
import 'admin_panel.dart';
import 'settings_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()..listenToEvents()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusVibe',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => const CampusVibeHomePage(),
        '/adminPanel': (context) => const AdminPanelPage(),
        '/userProfile': (context) => const UserProfileScreen(),
        '/comments': (context) => const CommentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/favorites': (context) => const FavoritesPage(),
        '/results': (context) => const ResultsPage(),
        '/clubEdit': (context) => const ClubEditPage(),
        '/clubs': (context) => const ClubListScreen(),
        '/settings': (context) => const SettingsScreen(),

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