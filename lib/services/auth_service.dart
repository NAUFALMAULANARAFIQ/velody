import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Instance Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Fungsi REGISTER (Daftar)
  Future<String?> signUp({
    required String email, 
    required String password, 
    required String username
  }) async {
    try {
      // Bikin akun di Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      User? user = result.user;

      // Simpan data tambahan (username) ke Firestore Database
      // Collection: users -> Doc: UID
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'username': username,
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
      });

      return null; // Null artinya sukses gak ada error
    } on FirebaseAuthException catch (e) {
      return e.message; // Balikin pesan errornya
    }
  }

  // 2. Fungsi LOGIN (Masuk)
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message; // Error (misal: password salah)
    }
  }

  // 3. Fungsi LOGOUT (Keluar)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. Ambil User yang sedang login sekarang
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}