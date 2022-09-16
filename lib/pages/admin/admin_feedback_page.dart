import 'package:flutter/material.dart';
import 'package:lsapp/pages/admin/admin_sugerencias_page.dart';

class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({Key? key}) : super(key: key);

  @override
  State<AdminFeedbackPage> createState() => _AdminFeedbackPageState();
}

class _AdminFeedbackPageState extends State<AdminFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text("COMENTARIOS"),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminSugerenciasPage()),
                );
              },
              child: Container(
                height: 120.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Text("Sugerencias"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text("Recomendaciones"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
