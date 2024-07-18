import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Remplacez par l'adresse IP de votre machine

  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    const url = '$baseUrl/api/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    const url = '$baseUrl/api/users';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 409) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registering: $e');
    }
  }
}
