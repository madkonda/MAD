import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> getCategories() async {
    final response =
        await http.get(Uri.parse('https://opentdb.com/api_category.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['trivia_categories'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<dynamic>> getQuestions({
    required int amount,
    required String category,
    required String difficulty,
    required String type,
  }) async {
    final url =
        'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=$type&encode=base64';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
