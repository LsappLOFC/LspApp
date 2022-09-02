import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lsapp/pages/home/file_page.dart';
import 'package:lsapp/pages/home/main_page.dart';
import 'package:lsapp/pages/home/settings_page.dart';

class HomeControllerPage extends StatefulWidget {
  const HomeControllerPage({Key? key}) : super(key: key);

  @override
  State<HomeControllerPage> createState() => _HomeControllerPageState();
}

class _HomeControllerPageState extends State<HomeControllerPage> {
  int _index = 0;
  bool isSelected = false;
  final pages = [
    const FilePage(),
    const MainPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.0,
        animationCurve: Curves.linear,
        color: Colors.black12,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        items: const [
          Icon(
            Icons.file_copy_outlined,
            color: Colors.white,
            size: 35.0,
          ),
          Icon(
            Icons.handshake_outlined,
            color: Colors.white,
            size: 35.0,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
            size: 35.0,
          ),
        ],
        onTap: ((index) {
          setState(() {
            _index = index;
          });
        }),
      ),
    );
  }
}
