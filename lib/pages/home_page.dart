import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar:
          CurvedNavigationBar(backgroundColor: Colors.blue, items: [
        Icon(
          Icons.file_copy_outlined,
          color: Colors.blue,
          size: 35.0,
        ),
        Icon(
          Icons.handshake_outlined,
          color: Colors.blue,
          size: 35.0,
        ),
        Icon(
          Icons.settings,
          color: Colors.blue,
          size: 35.0,
        ),
      ]),
    );
  }
}
