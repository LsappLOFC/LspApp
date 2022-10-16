import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/pages/auth/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainControllerPage());
}
