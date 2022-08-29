import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lsapp/pages/configuration.dart';
import 'package:lsapp/pages/files.dart';
import 'package:lsapp/pages/translate.dart';

class HomePage extends StatefulWidget {
  final int navCoord;
  const HomePage({Key? key, required this.navCoord}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = -1;
  @override
  void initState() {
    _selectedIndex = widget.navCoord;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  navigate() {
    switch (_selectedIndex) {
      case 0:
        return const Files();
      case 1:
        return const Translate();
      case 2:
        return const Configuration();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: navigate(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        items: const [
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
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
