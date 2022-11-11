// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/utilities/constraints.dart';
import 'package:lspapp/services/comment_service.dart';

CommentService commentService = CommentService();

final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

PreferredSizeWidget myMainAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: myAppBarTitleStyle(),
    ),
    bottomOpacity: 0,
    elevation: 0,
    centerTitle: true,
    backgroundColor: myMainColor,
    automaticallyImplyLeading: false,
  );
}

PreferredSizeWidget? mySecundaryAppBar(BuildContext context, String label) {
  return AppBar(
    backgroundColor: myMainColor,
    centerTitle: true,
    title: Text(
      label,
      style: mySecundaryAppBarTitleStyle(),
    ),
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(
          context,
        );
      },
      child: const Icon(
        Icons.arrow_back,
        size: 35.0,
        color: Colors.white,
      ),
    ),
  );
}

Divider myDivider() {
  return Divider(
    height: 10,
    thickness: 2,
    color: myMainColor,
  );
}

Future<dynamic> popUpSendComment(
    BuildContext context, String comment, String commentType) {
  return showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          title: Text(
            commentType == 'recomendacion'
                ? 'Enviar Recomendación'
                : "Enviar Sugerencia",
            style: popTitleStyle(),
          ),
          content: Text(
            commentType == 'recomendacion'
                ? '¿Enviar esta recomendación?'
                : "¿Enviar esta sugerencia?",
            style: popUpBodyStyle(),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO"),
            ),
            TextButton(
              onPressed: () {
                commentService.createComment(
                    comment, commentType, currentUserUid);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("SI"),
            ),
          ],
        )),
  );
}

Container sendButton(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * 0.25,
    decoration: BoxDecoration(
      color: myMainColor,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Icon(
      Icons.front_hand_outlined,
      size: 60.0,
      color: Colors.white,
    ),
  );
}
