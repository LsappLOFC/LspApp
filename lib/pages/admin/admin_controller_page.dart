import 'package:flutter/material.dart';
import 'package:lsapp/pages/admin/admin_feedback_page.dart';
import 'package:lsapp/pages/admin/admin_main_page.dart';
import 'package:lsapp/pages/admin/admin_settings_page.dart';

class AdminControllerPage extends StatefulWidget {
  const AdminControllerPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerPage> createState() => _AdminControllerPageState();
}

class _AdminControllerPageState extends State<AdminControllerPage> {
  int _index = 0;
  final pages = [
    AdminFeedbackPage(),
    AdminMainPage(),
    AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_mark,
            ),
            label: "Feedback",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Settings",
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
