import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoService {
  Future<List<Todo>> fetchTodos() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Todo.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> delete(int id) async {
    final response = await http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'));
    print('Delete response: ${response.statusCode}');
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
    print('Update response: ${response.statusCode}');
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

class AddAndDeleteScreen extends StatefulWidget {
  @override
  _AddAndDeleteScreenState createState() => _AddAndDeleteScreenState();
}

class _AddAndDeleteScreenState extends State<AddAndDeleteScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await _todoService.fetchTodos();
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      print('Failed to load todos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load todos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DELETE AND EDIT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _todos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: CircleAvatar(
                      child: Icon(
                        todo.completed ? Icons.check : Icons.clear,
                        color: Colors.white,
                      ),
                      backgroundColor:
                          todo.completed ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: TodoActions(
                      onDelete: () => _deleteTodo(todo.id, index),
                      onEdit: () => _editTodoDialog(todo, index),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteTodo(int id, int index) async {
    try {
      print('Deleting todo with id: $id');
      await _todoService.delete(id);
      setState(() {
        _todos.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo deleted successfully')),
      );
    } catch (e) {
      print('Failed to delete todo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete todo: $e')),
      );
    }
  }

  Future<void> _editTodoDialog(Todo todo, int index) async {
    TextEditingController titleController =
        TextEditingController(text: todo.title);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  print('Updating todo with id: ${todo.id}');
                  await _todoService.update(todo.id, titleController.text);
                  setState(() {
                    _todos[index] = Todo(
                      id: todo.id,
                      title: titleController.text,
                      completed: todo.completed,
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Todo updated successfully')),
                  );
                } catch (e) {
                  print('Failed to update todo: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update todo: $e')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class TodoActions extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoActions({
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            print('Delete button pressed');
            onDelete();
          },
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            print('Edit button pressed');
            onEdit();
          },
        ),
      ],
    );
  }
}
