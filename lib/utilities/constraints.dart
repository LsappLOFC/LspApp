// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const webServiceUrl = ('https://lsp-nlp-service.herokuapp.com/LSP');
const urlVideo =
    'https://firebasestorage.googleapis.com/v0/b/lspapp-63012.appspot.com/o/LSPAPP%20DEMO.mp4?alt=media&token=aabd99f8-34e5-4ab4-9d80-674bb822645b';
final signDictionary = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'K',
  'L',
  'LL',
  'M',
  'N',
  'Ñ',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  'ENFERMO',
  'HOSPITAL',
  'PERU',
  'MI',
  'COMER',
  'ESCUCHAR',
  'TOMAR',
  'MI',
  'YO',
  'SI',
  'CUANTO',
  'DONDE',
  'TU',
  'CUANDO',
  'QUE',
  'PORQUE',
  'COMO',
  'QUIEN',
  'AYUDA',
  'BAÑO',
  'CUAL',
  'AÑO',
  'DIA',
  'ESTUDIAR',
  'MAMA',
  'PAPA',
  'NOCHE',
  'NOMBRE',
  'TRABAJAR'
];

const Color myMainColor = Color(0XFF007AFF);
const Color mySecundaryColor = Color.fromARGB(43, 139, 198, 207);
const Color myBlueGreyColor = Colors.blueGrey;

TextStyle appTitle() {
  return GoogleFonts.poppins(
      fontSize: 72,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white);
}

TextStyle popTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}

TextStyle myContentTextStyle() {
  return GoogleFonts.poppins(
    fontSize: 18,
  );
}

TextStyle myTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle mySubTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle myRadiusTextStyle() {
  return GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle myAppBarTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

TextStyle uploadFileTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: myMainColor,
  );
}

TextStyle mySecundaryAppBarTitleStyle() {
  return GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: myMainColor,
        width: 2.0,
      ));
}

InputDecoration myInputDecoration(String hintText) {
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
    hintText: hintText,
    filled: true,
    fillColor: Colors.white,
  );
}
