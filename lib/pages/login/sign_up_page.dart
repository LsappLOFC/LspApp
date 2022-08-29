import 'package:flutter/material.dart';
import 'package:lsapp/pages/login/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150.0,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            child: const Text(
                              "Registrarme",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25.0,
                                color: Colors.blue,
                              ),
                            ),
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()),
                            );
                          },
                          child: Container(
                            child: const Text(
                              "Ingresar",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25.0,
                                color: Colors.black45,
                              ),
                            ),
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/images/img.png",
                          scale: 1.8,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
