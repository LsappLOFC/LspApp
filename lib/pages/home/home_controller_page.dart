// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/utilities/widgets.dart';
import 'package:lspapp/pages/home/file_page.dart';
import 'package:lspapp/pages/home/main_page.dart';
import 'package:lspapp/pages/settings/settings_page.dart';

class HomeControllerPage extends StatefulWidget {
  const HomeControllerPage({Key? key}) : super(key: key);

  static String id = '/home';

  @override
  State<HomeControllerPage> createState() => _HomeControllerPageState();
}

class _HomeControllerPageState extends State<HomeControllerPage> {
  int _index = 0;
  bool isSelected = false;
  final pages = [
    FilePage(),
    MainPage(),
    SettingsPage(),
  ];

  final pagesName = ["Traducir archivos", "", "Configuración"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      backgroundColor: mySecundaryColor,
      appBar: myAppBar(),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        animationCurve: Curves.linear,
        color: myBlueGreyColor,
        buttonBackgroundColor: myMainColor,
        backgroundColor: mySecundaryColor,
        items: [
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

  PreferredSizeWidget? myAppBar() {
    return _index != 1 ? myMainAppBar(pagesName[_index]) : null;
  }
}
