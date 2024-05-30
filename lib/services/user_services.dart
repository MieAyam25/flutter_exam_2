import 'dart:convert';
import 'package:flutter_exam_2/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'https://dummy.restapiexample.com/api';
  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/v1/employees'));
      final body = response.body;
      final result = jsonDecode(body);
      List<User> users = List<User>.from(
        result['data'].map(
          (user) => User.fromJson(user),
        ),
      );
      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
