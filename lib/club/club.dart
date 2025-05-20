class Club {
  final String id;
  final String name;
  final String description;
  final String email;
  final String logoAssetPath;
  final List<ClubEvent> events;

  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.email,
    required this.logoAssetPath,
    required this.events,
  });
}

class ClubEvent {
  final String title;
  final String description;
  final String date;
  final String location;
  final String imagePath;

  ClubEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imagePath,
  });
}