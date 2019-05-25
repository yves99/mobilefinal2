import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/register.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/friend.dart';
import './ui/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobilefinal2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => loginScreen(),
        '/register': (context) => registerScreen(),
        '/home': (context) => homeScreen(),
        '/profile': (context) => profileScreen(),
        '/friend': (context) => friendScreen(),
        '/todo': (context) => todoScreen(),
      },
    );
  }
}
