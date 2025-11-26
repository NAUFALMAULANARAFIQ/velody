import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_mobile/data/models/playlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_mobile/data/models/songs.dart';

class PlaylistService {
  static const String baseUrl = "http://10.0.2.2:8000/api/playlists";

  static Future<List<PlaylistModel>> getPlaylists() async {
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
        return body.map((e) => PlaylistModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> createPlaylist(String name, String descripsion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return false;

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"name": name, "descripsion" : descripsion}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addSongToPlaylist(int playlistId, int songId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        print("Add Song: Token kosong");
        return false;
      }

      final url = "$baseUrl/$playlistId/songs"; 
      print("Add Song Request: $url");
      print("Data: id_songs = $songId");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"id_songs": songId}),
      );

      print("Status Code: ${response.statusCode}");
      print("Body Error: ${response.body}"); 
      return response.statusCode == 200;
    } catch (e) {
      print("Error Koneksi: $e");
      return false;
    }
  }

  static Future<List<Song>> getSongsByPlaylistId(int playlistId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return [];

      final url = "$baseUrl/$playlistId/songs"; 
      print("Fetching songs from: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("Status Songs: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        
        print("Dapat ${body.length} lagu");
        
        return body.map((e) => Song.fromJson(e)).toList();
      }
      
      print("Gagal ambil lagu: ${response.body}");
      return [];
    } catch (e) {
      print("Error Service: $e");
      return [];
    }
  }

}