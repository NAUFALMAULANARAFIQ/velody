import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  // Ambil Data Profil User yang Sedang Login
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      // 1. Cek siapa yang login (ambil UID-nya)
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) return null; // Kalau gak ada yang login

      // 2. Ambil dokumen user dari Firestore berdasarkan UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Gagal ambil profil: $e");
      return null;
    }
  }
}