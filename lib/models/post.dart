// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostResult {
  int id;
  String name;
  String email;
  String body;

  PostResult({
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory PostResult.createPostResult(Map<String, dynamic> object) {
    return PostResult(
      id: object['id'] ?? 0,
      name: object['name'] ?? '',
      email: object['email'] ?? '',
      body: object['body'] ?? '',
    );
  }

  static Future<List<PostResult>> fetchPosts() async {
    String apiURL = "https://jsonplaceholder.typicode.com/comments";
    var apiResult = await http.get(Uri.parse(apiURL));
    var jsonObject = json.decode(apiResult.body) as List;
    return jsonObject.map((e) => PostResult.createPostResult(e)).toList();
  }

  static Future<PostResult> connectToAPI(String name, String email, String body) async {
    String apiURL = "https://jsonplaceholder.typicode.com/comments";

    var apiResult = await http.post(Uri.parse(apiURL), body: {
      "name": name,
      "email": email,
      "body": body,
    });
    var jsonObject = json.decode(apiResult.body);

    return PostResult.createPostResult(jsonObject);
  }
}
