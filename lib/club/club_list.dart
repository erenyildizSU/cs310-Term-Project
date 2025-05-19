import 'club.dart';

final List<Club> clubs = [
  Club(
    name: 'Economics and Management Club',
    description: 'Founded in 1999, EIK is a career-focused student club.',
    email: 'eik@sabanciuniv.edu',
    logoAssetPath: 'assets/eik-logo.jpeg',
    events: [
      ClubEvent(
        title: 'Networking Fair',
        description: 'Panels and networking with professionals.',
        date: '15.04.2025 / 14:00',
        location: 'FENS G032',
        imagePath: 'assets/networking_fair.jpg',

      ),
      ClubEvent(
        title: 'Recruitment Days',
        description: 'Are you ready to meet your dream company?',
        date: '23.04.2025 / 19:30',
        location: 'UC',
        imagePath: 'assets/recruitment.jpg',
      ),
    ],
  ),
  Club(
    name: 'MUZIKUS',
    description: 'Muzikus, founded in 1999 at Sabanci University, promotes campus music through diverse events and studio facilities.',
    email: 'muzikus@sabanciuniv.edu',
    logoAssetPath: 'assets/müzikus_logo.png',
    events: [
      ClubEvent(
        title: 'Pajama Party',
        description: 'Karaoke night in pajamas!',
        date: '20.03.2025 / 20:00',
        location: 'Hangar',
        imagePath: 'assets/pajamas.png',
      ),
      ClubEvent(
        title: 'Winter Town',
        description: 'Winter celebration with music.',
        date: '23.03.2025 / 22:00',
        location: 'UC',
        imagePath: 'assets/winter_town.png',
      ),
    ],
  ),
  Club(
    name: 'ARTELIER Fine Arts Club',
    description: 'All participants who want to spend time on art and pursue their dreams in life are invited to the club.',
    email: 'artelier@sabanciuniv.edu',
    logoAssetPath: 'assets/artelier-logo.png',
    events: [
      ClubEvent(
        title: 'Amigurimu Workshop',
        description: 'Learn to make your own amigurimu figures with soft threads.',
        date: '22.03.2025 / 20:00',
        location: 'Fass 1097',
        imagePath: 'assets/amigurumi.jpg',
      ),
      ClubEvent(
        title: 'Succulent Pot Painting',
        description: 'Artelier is organizing a succulent pot painting workshop so that you can give your loved ones a gift!',
        date: '25.03.2025 / 22:00',
        location: 'UC',
        imagePath: 'assets/succulent.jpg',
      ),
    ],
  ),
  Club(
    name: 'Tea Talks with CEOs Club',
    description: 'It is a club that has adopted the principle of bringing together the distinguished students of Sabancı University with leaders in their fields in the world and in Türkiye, and taking examples from their life stories and advice.',
    email: 'teatalks@sabanciuniv.edu',
    logoAssetPath: 'assets/club_logos/teatalks_logo.jpeg',
    events: [
      ClubEvent(
        title: 'Work-Life Harmony',
        description: 'Balancing work and private life is not always easy... So how can we achieve this?',
        date: '03.05.2025 / 20:00',
        location: 'UC',
        imagePath: 'assets/activity_photos/harmony.jpg',
      ),
      ClubEvent(
        title: 'Long-Term Internship Program',
        description: "Are you ready for an unforgettable development process in your business life with Anadolu Efes' Project Future Long-Term Internship Program?.",
        date: '15.05.2025 / 19:00',
        location: 'FENS G32',
        imagePath: 'assets/activity_photos/anadolu_efes.jpg',
      ),
    ],
  ),
  Club(
    name: 'SUDANCE',
    description: "Representing the unity of those who are interested in dance, those who love dance, and those who perceive dance as a way of life, SuDance's dance courses and events held throughout the year attract great interest from our university's students and staff.",
    email: 'sudance@sabanciuniv.edu',
    logoAssetPath: 'assets/club_logos/sudance.png',
    events: [
      ClubEvent(
        title: 'Tango Latino Night',
        description: 'We meet on this special night filled with the magic of both Latin and tango songs!',
        date: '08.05.2025 / 20:00',
        location: 'Hangar',
        imagePath: 'assets/activity_photos/latino.jpg',
      ),
      ClubEvent(
        title: 'Disco Fever',
        description: "Get ready for a night full of glitter, energy and dance!",
        date: '27.05.2025 / 22:00',
        location: 'Sabanci Performance Center',
        imagePath: 'assets/activity_photos/disco.jpg',
      ),
    ],
  ),
  Club(
    name: 'Sailing Club',
    description: "The club, which offers university students the opportunity to get acquainted with the sea and sailing, offers yacht training opportunities to its members, starting with 1* training and then with 2* and SUSAIL captains, respectively.",
    email: 'yelken@sabanciuniv.edu',
    logoAssetPath: 'assets/club_logos/susail.jpg',
    events: [
      ClubEvent(
        title: 'Adalar',
        description: 'We are sailing to the Burgazada.',
        date: '11.05.2025',
        location: 'Burgazada',
        imagePath: 'assets/activity_photos/adalar.jpg',
      ),
      ClubEvent(
        title: 'We are going to Marmaris!',
        description: "Join us to increase your sailing experience and have fun while the weather warms up!",
        date: '17.05.2025',
        location: 'Marmaris',
        imagePath: 'assets/activity_photos/marmaris.jpg',
      ),
    ],
  ),
];
