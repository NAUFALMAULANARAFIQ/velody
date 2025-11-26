import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/songs.dart';

class SongService {
  static const String baseUrl = "http://10.0.2.2:8000/api"; 

  static Future<List<Song>> getSongs() async {
    final url = Uri.parse("$baseUrl/songs");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        List<dynamic> data;
        if (body is List) {
          data = body; 
        } else if (body is Map<String, dynamic> && body.containsKey('data')) {
          data = body['data'];
        } else {
          print("Unexpected JSON format: $body");
          return [];
        }

        return data.map((e) => Song.fromJson(e)).toList();
      } else {
        print("Server Error: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }

  static Future<Song?> getSongById(int id) async {
    final url = Uri.parse("$baseUrl/songs/$id");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final data = body is Map<String, dynamic> && body.containsKey('data')
            ? body['data']
            : body;
        return Song.fromJson(data);
      } else {
        print("Server Error: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      print("Connection Error: $e");
      return null;
    }
  }
}
