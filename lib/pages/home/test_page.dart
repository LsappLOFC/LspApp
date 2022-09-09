import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(child: Text("ADMIN PAGE")),
            const SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
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
                    "SALIR",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
