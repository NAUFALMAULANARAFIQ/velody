import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/playlist.dart';
import '../data/models/songs.dart'; // Jangan lupa import model Song

class PlaylistService {
  
  // 1. Ambil Semua Playlist (Untuk Halaman Library)
  static Future<List<PlaylistModel>> getPlaylists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('playlists').get();
      return snapshot.docs.map((doc) => PlaylistModel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error ambil playlist: $e");
      return [];
    }
  }

  // 2. Buat Playlist Baru (Dipanggil di Dialog Create)
  static Future<void> createPlaylist(String name, String description) async {
    try {
      await FirebaseFirestore.instance.collection('playlists').add({
        'name': name,
        'description': description,
        'songs': [], // Awalnya kosong
        'created_at': FieldValue.serverTimestamp(), // Biar tau kapan dibuat
      });
    } catch (e) {
      print("Gagal buat playlist: $e");
    }
  }

  // 3. Tambah Lagu ke Playlist (Dipanggil di Sheet AddToPlaylist)
  static Future<bool> addSongToPlaylist(String playlistId, String songId) async {
    try {
      await FirebaseFirestore.instance.collection('playlists').doc(playlistId).update({
        'songs': FieldValue.arrayUnion([songId]) // arrayUnion mencegah duplikat
      });
      return true;
    } catch (e) {
      print("Gagal nambah ke playlist: $e");
      return false;
    }
  }

  // 4. Ambil Detail Lagu dalam Playlist (Dipanggil di PlaylistDetailPage)
  // Ini agak tricky: Kita ambil ID lagunya dulu dari Playlist, baru ambil data aslinya dari collection Songs
  static Future<List<Song>> getSongsByPlaylistId(String playlistId) async {
    try {
      // A. Ambil Dokumen Playlist-nya dulu
      DocumentSnapshot playlistDoc = await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlistId)
          .get();

      if (!playlistDoc.exists) return [];

      // B. Ambil array 'songs' yang isinya cuma ID ["lagu_1", "lagu_2"]
      Map<String, dynamic> data = playlistDoc.data() as Map<String, dynamic>;
      List<dynamic> songIds = data['songs'] ?? [];

      List<Song> songs = [];

      // C. Looping ID tersebut untuk ambil data lengkap dari collection 'songs'
      for (String songId in songIds) {
        DocumentSnapshot songDoc = await FirebaseFirestore.instance
            .collection('songs')
            .doc(songId)
            .get();

        if (songDoc.exists) {
          songs.add(Song.fromFirestore(songDoc));
        }
      }

      return songs;
    } catch (e) {
      print("Error ambil lagu di playlist: $e");
      return [];
    }
  }
}