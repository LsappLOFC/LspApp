import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilePage extends StatefulWidget {
  const FilePage({Key? key}) : super(key: key);

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  bool senasIsSelected = true;
  bool textIsSelected = false;

  bool showContent() {
    if (senasIsSelected) {
      return true;
    } else {
      return false;
    }
  }

  void _pickFile() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (res == null) {
      return;
    }
    print(res.files.first.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Subir Archivos",
              style: GoogleFonts.poppins(
                fontSize: 32.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              width: 180.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                gradient: const LinearGradient(
                  colors: [
                    Color(0XFF007AFF),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  senasIsSelected
                      ? Container(
                          width: 66.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0)),
                          child: const Center(
                            child: Text(
                              "Señas",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              textIsSelected = !textIsSelected;
                              senasIsSelected = !senasIsSelected;
                            });
                          },
                          child: const Text(
                            "Señas",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                  textIsSelected
                      ? Container(
                          width: 66.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0)),
                          child: const Center(
                            child: Text(
                              "Text",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              textIsSelected = !textIsSelected;
                              senasIsSelected = !senasIsSelected;
                            });
                          },
                          child: const Text(
                            "Text",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          showContent()
              ? Image.asset(
                  "assets/images/img_2.png",
                  scale: MediaQuery.of(context).size.height * 0.0024,
                )
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0XFF007AFF),
                          width: 2.0,
                        )),
                  ),
                ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                child: InkWell(
                  onTap: () {
                    _pickFile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.upload_sharp,
                        size: 30.0,
                        color: Color(0XFF007AFF),
                      ),
                      Text(
                        "Elegir Archivos",
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF007AFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, left: 40.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Tipos de archivos admitidos: \nmp3, mp4, txt",
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
