import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id; // Ubah dari int ke String (ID Firebase itu huruf & angka)
  final String title;
  final String artist;
  final String thumbnail; // Ini untuk cover_url dari Firebase
  final String fileUrl;   // Ini untuk audio_url dari Firebase
  final int duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.fileUrl,
    required this.duration,
  });

  // 1. Getter untuk UI kamu
  // Karena UI kamu memanggil 'song.customCoverUrl', kita arahkan langsung ke thumbnail.
  // Jadi kamu TIDAK PERLU ubah codingan di UI.
  String get customCoverUrl => thumbnail;

  // 2. Factory Utama: Mengubah Data Firebase jadi Object Song
  factory Song.fromFirestore(DocumentSnapshot doc) {
    // Ambil data di dalam dokumen
    Map data = doc.data() as Map<String, dynamic>;

    return Song(
      // doc.id adalah ID unik dari dokumen Firebase
      id: doc.id, 
      
      title: data['title'] ?? 'Tanpa Judul',
      
      // Pastikan key-nya 'artist_name' sesuai input manual kita tadi
      artist: data['artist_name'] ?? 'Unknown Artist', 
      
      // Ambil link gambar, kalau null kasih placeholder
      thumbnail: data['cover_url'] ?? 'https://placehold.co/100', 
      
      // Ambil link lagu
      fileUrl: data['audio_url'] ?? '',
      
      // Ambil durasi, pastikan jadi integer
      duration: _parseDuration(data['duration']), 
    );
  }

  // Helper kecil buat jaga-jaga kalau durasi tersimpan sebagai String
  static int _parseDuration(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // 3. Factory JSON (Opsional/Legacy)
  // Disimpan jaga-jaga kalau ada bagian app yang pakai format JSON lama
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id_songs']?.toString() ?? '0', // Konversi ke string
      title: json['title'] ?? '',
      artist: json['artist'] is Map ? json['artist']['name'] : json['artist'] ?? '',
      thumbnail: json['cover_image'] ?? '',
      fileUrl: json['file_url'] ?? '',
      duration: _parseDuration(json['duration']),
    );
  }
}