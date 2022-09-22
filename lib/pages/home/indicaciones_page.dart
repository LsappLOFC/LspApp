import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/main_controller.dart';

class IndicacionesPage extends StatefulWidget {
  const IndicacionesPage({Key? key}) : super(key: key);

  @override
  State<IndicacionesPage> createState() => _IndicacionesPageState();
}

class _IndicacionesPageState extends State<IndicacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainControllerPage()),
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
                    "Indicaciones de Uso",
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
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 2,
                      color: Colors.blue,
                    ),
                  ),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Scelerisque aliquet pharetra facilisis ipsum sit eget aliquam volutpat turpis. Lectus risus maecenas felis donec non sed purus eu sed. Vel risus est dui, nunc, ornare at dolor. Tempus integer eu, tincidunt urna sed ut diam. Neque, lacinia suspendisse in tempor pharetra a lacus. Pellentesque interdum auctor neque aliquet nec diam at vel imperdiet. Porta porttitor varius pharetra morbi eget sociis odio. Justo, tellus congue aliquet pulvinar quisque bibendum aliquet facilisi.",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainControllerPage()),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Entendido",
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
