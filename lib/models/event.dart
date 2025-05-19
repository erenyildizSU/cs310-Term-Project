class Event {
  final String id;
  final String name;
  final String description;
  final String posterUrl;
  final String date;
  final String time;
  final String venue;
  final String createdBy;
  final List<String> attendees;
  final List<String> favorites;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.posterUrl,
    required this.date,
    required this.time,
    required this.venue,
    required this.createdBy,
    required this.attendees,
    required this.favorites,
  });

  factory Event.fromMap(Map<String, dynamic> map, String docId) {
    return Event(
      id: docId,
      name: map['title'] ?? '',
      description: map['description'] ?? '',
      posterUrl: map['imageUrl'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      venue: map['location'] ?? '',
      createdBy: map['createdBy'] ?? '',
      attendees: List<String>.from(map['attendees'] ?? []),
      favorites: List<String>.from(map['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': name,
      'description': description,
      'imageUrl': posterUrl,
      'date': date,
      'time': time,
      'location': venue,
      'createdBy': createdBy,
      'attendees': attendees,
      'favorites': favorites,
      'createdAt': DateTime.now(),
    };
  }
}
