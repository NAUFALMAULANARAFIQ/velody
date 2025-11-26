import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_mobile/data/models/songs.dart';

class FavoriteService {
  static const String baseUrl = "http://10.0.2.2:8000/api/favorites";

static Future<bool> toggleFavorite(int songId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); 
      if (token == null) {
        print("❌ GAGAL: Token kosong! User belum login atau sesi habis.");
        return false; 
      }
      
      print("Mengirim Request...");
      print("Song ID yang dikirim: $songId");
      print("Token yang dikirim: $token"); 

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "id_songs": songId,
        }),
      );

      print("Server Response: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error Koneksi: $e");
      return false;
    }
  }

  static Future<List<Song>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return [];
      final response = await http.get(
        Uri.parse(baseUrl), 
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => Song.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}