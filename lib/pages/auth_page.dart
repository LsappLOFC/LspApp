import 'package:flutter/material.dart';
import 'package:lsapp/pages/sign-in-page.dart';
import 'package:lsapp/pages/sign-up-page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = false;

  void toogScrens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(showLoginPage: toogScrens);
    } else {
      return SignUpPage(showLoginPage: toogScrens);
    }
  }
}
