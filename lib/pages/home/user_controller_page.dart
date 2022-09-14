import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsapp/pages/home/home_controller_page.dart';
import 'package:lsapp/pages/home/test_page.dart';

class UserControllerPage extends StatefulWidget {
  const UserControllerPage({Key? key}) : super(key: key);

  @override
  State<UserControllerPage> createState() => _UserControllerPageState();
}

class _UserControllerPageState extends State<UserControllerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data?.docs.first.data() as Map<String, dynamic>;
            if (data["rol"] == "admin") {
              return const TestPage();
            } else {
              return const HomeControllerPage();
            }
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
