import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistModel {
  final String id; // 1. Ubah dari int ke String (ID Firestore itu huruf)
  final String name;
  final int songsCount;

  PlaylistModel({
    required this.id,
    required this.name,
    this.songsCount = 0,
  });

  // 2. Ganti 'fromJson' jadi 'fromFirestore' biar standar
  factory PlaylistModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    
    // Ambil array 'songs' dari database
    // Kalau belum ada isinya, kita anggap list kosong []
    List songs = data['songs'] ?? [];

    return PlaylistModel(
      id: doc.id, // ID diambil langsung dari ID Dokumen Firestore
      name: data['name'] ?? 'Untitled Playlist',
      
      // 3. Hitung jumlah lagu otomatis berdasarkan panjang array
      songsCount: songs.length, 
    );
  }
}