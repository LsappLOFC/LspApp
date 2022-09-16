import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static const int numItems = 5;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 100,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 50.0),
                alignment: Alignment.bottomLeft,
                child: Text("USUARIOS"),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 30,
                  width: 130,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5.0),
                      suffixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "search",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.hasData) {
                      List<dynamic> data = [];
                      snapshot.data!.docs.forEach((doc) {
                        data.add(doc.data());
                        print(doc.data());
                      });
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('nombre'),
                          ),
                          DataColumn(
                            label: Text('Correo'),
                          ),
                          DataColumn(
                            label: Text('estado'),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          data.length,
                          (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(data[index]["name"])),
                              DataCell(Text(data[index]["email"])),
                              DataCell(
                                  Text(data[index]["habilitado"].toString()))
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
