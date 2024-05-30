import 'package:flutter/material.dart';
import 'package:flutter_exam_2/models/user.dart';
import 'package:flutter_exam_2/services/user_services.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<User> users = [];

  void fetchUsers() async {
    final result = await UserService.fetchUsers();
    setState(() {
      users = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'JSON and RestAPI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    leading: user.profile_image != null &&
                            user.profile_image.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.profile_image),
                          )
                        : CircleAvatar(
                            child: Icon(Icons.person, color: Colors.white),
                            backgroundColor: Colors.grey,
                          ),
                    title: Text(
                      user.employee_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${user.employee_age}'),
                        Text('Salary: \$${user.employee_salary}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
