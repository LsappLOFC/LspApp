import 'package:flutter/material.dart';

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
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(40.0),topLeft: Radius.circular(40.0))
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Container(
                            child: Text("Registrarme", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                              color: Colors.blue,
                            ),),
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Container(
                            child: Text("Ingresar", style: TextStyle(
                              fontWeight: FontWeight.w500 ,
                              fontSize: 25.0,
                              color: Colors.black45,
                            ),),
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        Text("Correo electronico",),
                        Padding(
                          padding: EdgeInsets.only(left: 25,right: 25),
                          child: Container(
                            height: 60.0,
                            padding: EdgeInsets.only(left: 5,right: 5),
                            decoration: BoxDecoration(
                              color: Color(0xFFEDF6F9),
                              borderRadius: BorderRadius.circular(30.0)

                            ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,

                                ),
                              )),
                        )
                    ],)
                  ],
                ),
              ),
            ),          ],
        ),
      ),
    );
  }
}
