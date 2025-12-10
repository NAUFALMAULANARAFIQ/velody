import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/songs.dart';

class SongService {
  static Future<List<Song>> getSongs() async {
    try {
      print("🚀 Sedang mengambil lagu dari Firestore..."); // CCTV 1

      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('songs').get();
      
      print("📦 Ditemukan ${snapshot.docs.length} dokumen lagu."); // CCTV 2

      if (snapshot.docs.isEmpty) {
        print("⚠️ Waduh, collection 'songs' kosong beb!");
        return [];
      }

      List<Song> songs = snapshot.docs.map((doc) {
        // Cek data mentah biar tau kalau ada field yang salah
        // print("📄 Data mentah: ${doc.data()}"); 
        return Song.fromFirestore(doc);
      }).toList();

      print("✅ Berhasil memproses ${songs.length} lagu jadi object Song."); // CCTV 3
      return songs;

    } catch (e) {
      print("❌ ERROR PARAH BEB: $e"); // CCTV Error
      return [];
    }
  }

  // ... (Fungsi getSongById biarkan saja)
}