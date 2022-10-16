import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/pages/auth/auth_page.dart';
import 'package:lspapp/pages/home/user_controller_page.dart';

class MainControllerPage extends StatefulWidget {
  const MainControllerPage({Key? key}) : super(key: key);

  @override
  State<MainControllerPage> createState() => _MainControllerPageState();
}

class _MainControllerPageState extends State<MainControllerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return const UserControllerPage();
              } else {
                return const AuthPage();
              }
            }),
          ),
        ));
  }
}
