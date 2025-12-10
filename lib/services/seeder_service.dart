import 'package:cloud_firestore/cloud_firestore.dart';

class SeederService {
  // Data 10 Lagu Pilihan (Link GitHub Kamu)
  static final List<Map<String, dynamic>> songs = [
    {
      'title': 'what i wish just one person would say to me',
      'artist_name': 'LANY',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/what%20i%20wish%20just%20one%20person%20would%20say%20to%20me.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/what_i_wish_just_one_person_would_say_to_me.webp',
      'duration': 298,
    },
    {
      'title': '4 Seasons',
      'artist_name': 'Rex Orange County',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/4%20Seasons.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/4_Seasons.webp',
      'duration': 219,
    },
    {
      'title': 'A Sorrowful Reunion',
      'artist_name': 'Reality Club',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/A%20Sorrowful%20Reunion.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/A_Sorrowful_Reunion.webp',
      'duration': 178,
    },
    {
      'title': 'About You',
      'artist_name': 'The 1975',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/About%20You.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/About_You.webp',
      'duration': 170,
    },
    {
      'title': 'Bags',
      'artist_name': 'Clairo',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/Bags.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/Bags.webp',
      'duration': 178,
    },
    {
      'title': 'Euphoria',
      'artist_name': 'Keshi',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/Euphoria.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/Euphoria.webp',
      'duration': 198,
    },
    {
      'title': 'Fade Into You',
      'artist_name': 'Mazzy Star',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/Fade%20Into%20You.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/Fade_Into_You.webp',
      'duration': 231,
    },
    {
      'title': 'Hericane',
      'artist_name': 'LANY',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/Hericane.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/Hericane.webp',
      'duration': 186,
    },
    {
      'title': 'The Night We Met',
      'artist_name': 'Lord Huron',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/The%20Night%20We%20Met.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/The_Night_We_Met.webp',
      'duration': 317,
    },
    {
      'title': 'White Ferrari',
      'artist_name': 'Frank Ocean',
      'audio_url': 'https://naufalmaulanarafiq.github.io/assets-velody/songs/White%20Ferrari.mp3',
      'cover_url': 'https://naufalmaulanarafiq.github.io/assets-velody/album-cover/White_Ferrari.webp',
      'duration': 195,
    },
  ];

  static Future<void> uploadSongs() async {
    final CollectionReference songsRef = FirebaseFirestore.instance.collection('songs');

    for (var song in songs) {
      // Kita pakai title sebagai ID dokumen biar gak duplikat kalau diklik 2x
      String docId = song['title'].toString().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
      
      await songsRef.doc(docId).set(song);
      print("✅ Berhasil upload: ${song['title']}");
    }
  }
}