import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static final String baseUrl = "http://10.0.2.2:8000/api";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "email": email,
        "password": password,
      },
    );

    return jsonDecode(response.body);
  }
}
