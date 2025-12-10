import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/data/models/songs.dart';

class HistoryService {
  // Ambil ID User yang sedang login
  static String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }
    return user.uid;
  }

  // 1. Tambah ke History (Dipanggil saat klik lagu)
  static Future<void> addHistory(String songId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('history')
          .doc(songId) // Pakai ID lagu sebagai ID dokumen biar gak duplikat
          .set({
        'songId': songId,
        'played_at': FieldValue.serverTimestamp(), // Simpan waktu sekarang
      });
    } catch (e) {
      print("Gagal nambah history: $e");
    }
  }

  // 2. Ambil Daftar History
  static Future<List<Song>> getHistory() async {
    try {
      // Ambil list history, urutkan dari yang paling baru diputar
      QuerySnapshot historySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('history')
          .orderBy('played_at', descending: true)
          .get();

      if (historySnapshot.docs.isEmpty) return [];

      List<Song> historySongs = [];

      // Loop setiap history, ambil detail lagunya dari collection 'songs'
      for (var doc in historySnapshot.docs) {
        String songId = doc.id;

        DocumentSnapshot songDoc = await FirebaseFirestore.instance
            .collection('songs')
            .doc(songId)
            .get();

        // Cek kalau lagunya masih ada di database (belum dihapus admin)
        if (songDoc.exists) {
          historySongs.add(Song.fromFirestore(songDoc));
        }
      }

      return historySongs;
    } catch (e) {
      print("Gagal ambil history: $e");
      return [];
    }
  }
}