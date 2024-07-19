import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<dynamic>> fetchActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/api/activities'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<void> addActivity(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/activities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add activity');
    }
  }

  static Future<void> rateActivity(int activityId, int userId, int rating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/activities/$activityId/rate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': userId,
        'note': rating,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to rate activity');
    }
  }
}
