import 'package:flutter/material.dart';
import 'package:lsapp/pages/home/home_page.dart';
import 'package:lsapp/pages/login/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Container(
              child: Image.asset(
                "assets/images/img_1.png",
                scale: 2,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Container(
                          child: Text(
                            "Registrarme",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                              color: Colors.black45,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Text(
                            "Ingresar",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                              color: Colors.blue,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: Text(
                          "Correo electronico",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                            height: 60.0,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFEDF6F9),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: Text(
                          "Contraseña",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                            height: 60.0,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFEDF6F9),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage(
                                      navCoord: 1,
                                    )),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 85.0),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            width: 250.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF4285F4),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Text(
                              "INGRESAR",
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
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
