// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/model/user_model.dart';
import 'package:lspapp/pages/auth/login_page.dart';
import 'package:lspapp/pages/home/home_controller_page.dart';
import 'package:lspapp/pages/auth/user_disabled_page.dart';
import 'package:lspapp/pages/settings/recommendations_page.dart';
import 'package:lspapp/pages/settings/settings_page.dart';
import 'package:lspapp/pages/settings/suggestions_page.dart';

import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MyHomeApp.id,
      routes: {
        MyHomeApp.id: ((context) => MyHomeApp()),
        LoginPage.id: ((context) => LoginPage()),
        UserDisabledPage.id: ((context) => UserDisabledPage()),
        HomeControllerPage.id: ((context) => HomeControllerPage()),

        //!Settings
        SettingsPage.id: ((context) => SettingsPage()),
        RecommendationsPage.id: ((context) => RecommendationsPage()),
        SuggestionsPage.id: ((context) => SettingsPage()),
      },
    );
  }
}

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  static String id = '/';

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginPage();
          }
          return FutureBuilder<UserModel>(
            future: userService.getUserByEmail(snapshot.data!.email!),
            builder: (BuildContext context, usersnap) {
              if (!usersnap.hasData) {
                return LoginPage();
              }
              if (usersnap.data!.isEnabled!) {
                return HomeControllerPage();
              }
              return UserDisabledPage();
            },
          );
        },
      ),
    );
  }
}
