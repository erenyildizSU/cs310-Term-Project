import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';


class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Event> _events = [];
  List<Event> get events => _events;

  // Firestore'dan canlı veri dinle
  void listenToEvents() {
    _firestore
        .collection('events_detail')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _events = snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    });
  }

  // Yeni etkinlik ekle
  Future<void> addEvent(Event event) async {
    await _firestore.collection('events_detail').add(event.toMap());
  }

  // Attend işlemi
  Future<void> toggleAttend(String eventId, String userId) async {
    if (eventId.isEmpty || userId.isEmpty) return;

    final docRef = _firestore.collection('events_detail').doc(eventId);
    final doc = await docRef.get();

    if (doc.exists) {
      List<dynamic> current = doc['attendees'] ?? [];

      if (current.contains(userId)) {
        current.remove(userId);
      } else {
        current.add(userId);
      }

      await docRef.update({'attendees': current});
      notifyListeners(); // ❗️ UI'yi yenile
      print("✔️ [ATTEND] Updated attendees for $eventId: $current");
    } else {
      print("⚠️ [ATTEND] Event document not found for ID: $eventId");
    }
  }

  // Favorite işlemi
  Future<void> toggleFavorite(String eventId, String userId) async {
    if (eventId.isEmpty || userId.isEmpty) return;

    final docRef = _firestore.collection('events_detail').doc(eventId);
    final doc = await docRef.get();

    if (doc.exists) {
      List<dynamic> current = doc['favorites'] ?? [];

      if (current.contains(userId)) {
        current.remove(userId);
      } else {
        current.add(userId);
      }

      await docRef.update({'favorites': current});
      notifyListeners(); // ❗️ UI'yi yenile
      print("❤️ [FAVORITE] Updated favorites for $eventId: $current");
    } else {
      print("⚠️ [FAVORITE] Event document not found for ID: $eventId");
    }
  }

  // Belirli kulübün etkinliklerini filtrele
  List<Event> getEventsByCreator(String creatorId) {
    return _events.where((e) => e.createdBy == creatorId).toList();
  }
}