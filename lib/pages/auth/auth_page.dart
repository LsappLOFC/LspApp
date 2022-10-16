import 'package:flutter/material.dart';
import 'package:lspapp/pages/auth/sign-in-page.dart';
import 'package:lspapp/pages/auth/sign-up-page.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: showLoginPage
            ? SignInPage(showLoginPage: toogScrens)
            : SignUpPage(showLoginPage: toogScrens),
      ),
    );
  }
}
