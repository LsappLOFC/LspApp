import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsapp/pages/auth_page.dart';
import 'package:lsapp/pages/home_controller_page.dart';

class MainControllerPage extends StatefulWidget {
  const MainControllerPage({Key? key}) : super(key: key);

  @override
  State<MainControllerPage> createState() => _MainControllerPageState();
}

class _MainControllerPageState extends State<MainControllerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const HomeControllerPage();
          } else {
            return const AuthPage();
          }
        }),
      ),
    );
  }
}
