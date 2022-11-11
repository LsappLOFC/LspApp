// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color myMainColor = Color(0XFF007AFF);
const Color mySecundaryColor = Color.fromARGB(43, 139, 198, 207);
const Color myBlueGreyColor = Colors.blueGrey;

TextStyle popTitleStyle() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );
}

TextStyle popUpBodyStyle() {
  return TextStyle(fontSize: 16.0);
}

TextStyle myCommentBodyStyle() {
  return GoogleFonts.poppins(
    fontSize: 14.0,
  );
}

TextStyle myCommentSubTitleStyle() {
  return GoogleFonts.montserrat(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );
}

TextStyle myCommentTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 24.0,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  );
}

InputDecoration myCommentDecoration(String commentType) {
  return InputDecoration(
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.all(20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 3, color: myMainColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 3, color: myMainColor),
    ),
    hintText: "Ingrese sus $commentType aquí...",
    filled: true,
    fillColor: Colors.white,
  );
}

TextStyle mySettingTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );
}

TextStyle myAppBarTitleStyle() {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle mySecundaryAppBarTitleStyle() {
  return TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}
