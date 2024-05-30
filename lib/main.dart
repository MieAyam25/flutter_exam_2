import 'package:flutter/material.dart';
import 'package:flutter_exam_2/addAndDelete.dart';
import 'package:flutter_exam_2/models/post.dart';
import 'package:flutter_exam_2/pages/home_page_stateful.dart';
import 'package:flutter_exam_2/post.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20, // Ubah ukuran font sesuai kebutuhan
          ),
        ),
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: Colors.blue,
        leading: Container(),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            CustomButton(
              text: 'POST',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'GET',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstPage()),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'PUT & DELETE',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAndDeleteScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePageStateful();
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Added slight round corners
          ),
        ),
      ),
    );
  }
}
