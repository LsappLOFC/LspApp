import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/pages/admin/admin_controller_page.dart';
import 'package:lspapp/pages/home/home_controller_page.dart';
import 'package:lspapp/pages/home/user_disabled_page.dart';

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
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data?.docs.first.data() as Map<String, dynamic>;
            if (data["rol"] == "admin") {
              print(data);
              return const AdminControllerPage();
            } else {
              if (data["habilitado"] == false) {
                return const UserDisabledPage();
              }
              return const HomeControllerPage();
            }
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
