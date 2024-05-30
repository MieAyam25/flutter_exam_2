import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoService {
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Todo.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'));
    print('Delete response: ${response.statusCode}');  // Debug log
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete todo');
    }
  }

  Future<void> update(int id, String title) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'),
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'completed': false,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Update response: ${response.statusCode}');  // Debug log
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }
}

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
