import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminSugerenciasPage extends StatefulWidget {
  const AdminSugerenciasPage({Key? key}) : super(key: key);

  @override
  State<AdminSugerenciasPage> createState() => _AdminSugerenciasPageState();
}

class _AdminSugerenciasPageState extends State<AdminSugerenciasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 50.0,
              ),
              child: Container(
                child: Text(
                  "Sugerencias",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
