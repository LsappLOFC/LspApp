// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lsapp/pages/auth/auth_with_google.dart';
import 'package:lsapp/pages/home/indicaciones_page.dart';
import 'package:lsapp/pages/home/recomendaciones_page.dart';
import 'package:lsapp/pages/home/sugerencias_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum RadioValues {
  Baja,
  Media,
  Alta,
}

class _SettingsPageState extends State<SettingsPage> {
  RadioValues? values = RadioValues.Baja;
  final GoogleAuthService _authService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Text(
                "Configuracion",
                style: GoogleFonts.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 40.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Velocidad de señas",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: RadioValues.Baja,
                              groupValue: values,
                              activeColor: const Color(0XFF616161),
                              onChanged: (value) {
                                setState(() {
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Baja"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: RadioValues.Media,
                              groupValue: values,
                              activeColor: const Color(0XFF616161),
                              onChanged: (value) {
                                setState(() {
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Media"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: RadioValues.Alta,
                              groupValue: values,
                              activeColor: const Color(0XFF616161),
                              onChanged: (value) {
                                setState(() {
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Alta"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Indicaciones de uso",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_sharp,
                      size: 40.0,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IndicacionesPage()),
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Recomendaciones",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_sharp,
                      size: 40.0,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecomendacionesAPge()),
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Sugerencias",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_sharp,
                      size: 40.0,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SugerenciasPage()),
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Cerrar sesión",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    trailing: const Icon(
                      Icons.output_sharp,
                      size: 30.0,
                      color: Colors.blue,
                    ),
                    onTap: () async {
                      await _authService.signOutGoogle();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
