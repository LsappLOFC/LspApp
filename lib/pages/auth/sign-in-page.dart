// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignInPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String errCorreo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                "assets/images/img_1.png",
                scale: MediaQuery.of(context).size.height * 0.0040,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: widget.showLoginPage,
                          child: Text(
                            "Registrarme",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Ingresar",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: const Color(0xFF4285F4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 2.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Correo electrónico:",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        hintText: "Correo electrónico",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: ((value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                                .hasMatch(value)) {
                          return "Formato de correo incorrecto";
                        } else {
                          return null;
                        }
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 2.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        errCorreo,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 2.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Contraseña:",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurple,
                          ),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        hintText: "Contraseña",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      validator: ((validate) {
                        if (validate!.isEmpty) {
                          return "ingrese contraseña";
                        } else {
                          return null;
                        }
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: signIn,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        width: 300.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4285F4),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Text("Iniciar",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: Colors.white,
                            )),
                      ),
                    ),
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
