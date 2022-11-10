// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lspapp/model/user_model.dart';
import 'package:lspapp/pages/auth/login_page.dart';
import 'package:lspapp/pages/home/home_controller_page.dart';
import 'package:lspapp/pages/auth/user_disabled_page.dart';

final userDb = FirebaseFirestore.instance.collection("usuarios");
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class UserService {
  Future createUser(
      String uid, String name, String email, String imageUrl) async {
    var user = UserModel(
        name: name,
        email: email,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEnabled: true,
        type: 'user');

    final docRef = userDb
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, options) => user.toFirestore(),
        )
        .doc(uid);

    await docRef.set(user);
  }

  Future<UserModel> getUserByEmail(String email) async {
    String name = '';
    String email = '';
    String imageUrl = '';
    DateTime createdAt = DateTime.now();
    DateTime updatedAt = DateTime.now();
    bool isEnabled = true;
    String type = '';

    try {
      await userDb.where('correo', isEqualTo: email).get().then((event) {
        for (var doc in event.docs) {
          name = doc.data()["nombre"];
          email = doc.data()["email"];
          imageUrl = doc.data()["imagen"];
          createdAt = doc.data()["fechaHoraRegistro"];
          updatedAt = doc.data()["fechaHoraActualizacion"];
          isEnabled = doc.data()["habilitado"];
          type = doc.data()["type"];
        }
      });
    } catch (e) {}
    var user = UserModel(
        name: name,
        email: email,
        imageUrl: imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isEnabled: isEnabled,
        type: type);
    return user;
  }

  bool userIsEnabled(BuildContext context) {
    bool? status = true;
    try {
      userDb
          .where('correo', isEqualTo: _auth.currentUser!.email!)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          status = doc.data()["habilitado"];
        }
      });
    } catch (e) {}
    return status!;
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await _auth.signInWithCredential(credential).then((value) async {
        try {
          final docRef = userDb.doc(value.user!.uid);
          await docRef.get().then(
            (DocumentSnapshot doc) async {
              if (doc.exists) {
                var status = userIsEnabled(context);
                if (status) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeControllerPage.id, (_) => false);
                } else if (!status) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, UserDisabledPage.id, (_) => false);
                }
              } else {
                createUser(value.user!.uid, value.user!.displayName!,
                    value.user!.email!, value.user!.photoURL!);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeControllerPage.id, (_) => false);
              }
            },
          );
        } catch (e) {}
      });
    } catch (e) {}
  }

  void signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (_) => false);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
