import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecomendacionesAPge extends StatefulWidget {
  const RecomendacionesAPge({Key? key}) : super(key: key);

  @override
  State<RecomendacionesAPge> createState() => _RecomendacionesAPgeState();
}

class _RecomendacionesAPgeState extends State<RecomendacionesAPge> {
  final _textRecomendation = TextEditingController();

  Future saveData() async {
    final now = DateTime.now();
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final city = <String, dynamic>{
      "comment": _textRecomendation.text,
      "fechaHoraRegistro": now,
      "fechaHoraActualizacion": now,
      "type_comment": "recomendaciones",
      "estado_leido": false,
      "estado_eliminado": false,
      "user_Id": user!.uid,
      "visto": false,
    };
    await db
        .collection("comments")
        .doc()
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child: const Icon(
              Icons.arrow_back,
              size: 35.0,
              color: Color(0XFF007AFF),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: const EdgeInsets.only(bottom: 5.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0XFF007AFF),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      "Recomendaciones",
                      style: GoogleFonts.poppins(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                  child: Text(
                    "Envíanos tus recomendaciones sobre el uso de la Lengua de Señas Peruanas (LSP)",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 2,
                        color: Colors.blue,
                      ),
                    ),
                    child: TextField(
                      controller: _textRecomendation,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Ingrese sus recomendaciones aquí...",
                          filled: true,
                          fillColor: Colors.white),
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 10,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                    saveData();
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.35),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        alignment: Alignment.center,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(
                          Icons.front_hand_outlined,
                          size: 60.0,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
