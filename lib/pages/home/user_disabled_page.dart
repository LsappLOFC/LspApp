// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lspapp/services/user_service.dart';

class UserDisabledPage extends StatefulWidget {
  const UserDisabledPage({Key? key}) : super(key: key);

  static String id = '/disabledUser';

  @override
  State<UserDisabledPage> createState() => _UserDisabledPageState();
}

class _UserDisabledPageState extends State<UserDisabledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SU CUENTA ESTA INHABILITADA"),
            ElevatedButton(
              onPressed: () {
                UserService userService = UserService();
                userService.signOut(context);
              },
              child: Text(
                "SALIR",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
