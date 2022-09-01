import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lsapp/pages/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/foto.png"),
        fit: BoxFit.cover,
      )),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainControllerPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 50.0),
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            width: 250.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF82D00),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "COMENZAR",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
