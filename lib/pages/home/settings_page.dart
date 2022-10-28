// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lspapp/pages/auth/auth_with_google.dart';
import 'package:lspapp/pages/home/indicaciones_page.dart';
import 'package:lspapp/pages/home/recomendaciones_page.dart';
import 'package:lspapp/pages/home/sugerencias_page.dart';
import 'package:lspapp/pages/home/variables.dart' as variables;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum RadioValues {
  Lento,
  Normal,
  Rapido,
}

class _SettingsPageState extends State<SettingsPage> {
  RadioValues? values;
  final GoogleAuthService _authService = GoogleAuthService();
  @override
  void initState() {
    if (variables.selectedRadioValue == 0) {
      values = RadioValues.Lento;
    } else if (variables.selectedRadioValue == 1) {
      values = RadioValues.Normal;
    } else {
      values = RadioValues.Rapido;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(43, 139, 198, 207),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0XFF007AFF),
              padding: const EdgeInsets.only(top: 40.0, left: 20.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Configuración",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
                              value: RadioValues.Lento,
                              groupValue: values,
                              activeColor: const Color(0XFF007AFF),
                              onChanged: (value) {
                                setState(() {
                                  variables.selectedRadioValue = 0;
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Lento"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: RadioValues.Normal,
                              groupValue: values,
                              activeColor: const Color(0XFF007AFF),
                              onChanged: (value) {
                                setState(() {
                                  variables.selectedRadioValue = 1;
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Normal"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                              value: RadioValues.Rapido,
                              groupValue: values,
                              activeColor: const Color(0XFF007AFF),
                              onChanged: (value) {
                                setState(() {
                                  variables.selectedRadioValue = 2;
                                  values = value as RadioValues?;
                                });
                              }),
                          const Text("Rapido"),
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
                          color: Color(0XFF007AFF),
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
                          color: Color(0XFF007AFF),
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
                          color: Color(0XFF007AFF),
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
