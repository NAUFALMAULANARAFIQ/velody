import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_mobile/data/models/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String baseUrl = "http://10.0.2.2:8000/api/history";
  
  static Future<List<Song>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("GET HISTORY: Token tidak ditemukan!");
        return [];
      }

      print("GET HISTORY: Mengambil data dari $baseUrl...");
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("GET HISTORY Status: ${response.statusCode}");
      print("GET HISTORY Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        if (body.isEmpty) {
          print("GET HISTORY: Data dari server KOSONG []");
        } else {
          print("GET HISTORY: Berhasil dapat ${body.length} lagu");
        }
        return body.map((e) => Song.fromJson(e)).toList();
      } else {
        print("GET HISTORY Gagal: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error Koneksi GET History: $e");
      return [];
    }
  }

  static Future<void> addHistory(int songId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      print("Menyimpan Song ID $songId...");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"id_songs": songId}),
      );

      print("ADD HISTORY Status: ${response.statusCode}");
      print("ADD HISTORY Body: ${response.body}");
    } catch (e) {
      print("Error Koneksi ADD History: $e");
    }
  }
}