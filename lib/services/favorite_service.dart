import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/data/models/songs.dart';

class FavoriteService {
  
  // Helper: Ambil ID User yang sedang login
  static String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User belum login beb!");
    }
    return user.uid;
  }

  // 1. Toggle Favorite (Like / Unlike)
  static Future<bool> toggleFavorite(String songId) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(songId);

      final doc = await docRef.get();

      if (doc.exists) {
        // Kalau sudah ada -> HAPUS (Unlike)
        await docRef.delete();
        return false; // False = Tidak like lagi
      } else {
        // Kalau belum ada -> SIMPAN (Like)
        await docRef.set({
          'songId': songId,
          'added_at': FieldValue.serverTimestamp(),
        });
        return true; // True = Sekarang like
      }
    } catch (e) {
      print("Error toggle favorite: $e");
      return false;
    }
  }

  // 2. Cek Status (Apakah lagu ini dilike?)
  static Future<bool> isFavorite(String songId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(songId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // 3. Ambil Semua Favorit (VERSI TURBO / NGEBUT) 🚀
  static Future<List<Song>> getFavorites() async {
    try {
      // A. Ambil daftar ID lagu favorit user
      QuerySnapshot favSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .orderBy('added_at', descending: true)
          .get();

      if (favSnapshot.docs.isEmpty) return [];

      // B. Siapkan request pengambilan data secara BERSAMAAN (Paralel)
      // Kita tidak pakai 'await' di dalam loop, tapi kita kumpulkan dulu tugasnya
      List<Future<DocumentSnapshot>> tasks = favSnapshot.docs.map((doc) {
        return FirebaseFirestore.instance
            .collection('songs') // Ambil detail dari collection songs utama
            .doc(doc.id)
            .get();
      }).toList();

      // C. Jalankan semua tugas sekaligus! (Ini yang bikin cepat)
      List<DocumentSnapshot> songDocs = await Future.wait(tasks);

      // D. Ubah hasil data menjadi list Song
      List<Song> favoriteSongs = [];
      for (var doc in songDocs) {
        if (doc.exists) {
          favoriteSongs.add(Song.fromFirestore(doc));
        }
      }

      return favoriteSongs;
    } catch (e) {
      print("Error ambil favorites: $e");
      return [];
    }
  }
}