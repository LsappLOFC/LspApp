import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lspapp/pages/admin/admin_details_user_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
                      .where("rol", isEqualTo: "user")
                      .snapshots(),
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.hasData) {
                      List<dynamic> data = [];
                      snapshot.data!.docs.forEach((doc) {
                        data.add(doc.data());
                      });
                      return DataTable(
                        columnSpacing: 35.0,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('nombre'),
                          ),
                          DataColumn(
                            label: Text('Correo'),
                          ),
                          DataColumn(
                            label: Text('Habilitar'),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          snapshot.data!.docs.length,
                          (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Text(data[index]["name"]),
                              ),
                              DataCell(
                                InkWell(
                                  onTap: () {
                                    var id;
                                    snapshot.data!.docs.forEach((doc) {
                                      if (data[index]["email"] ==
                                          doc["email"]) {
                                        id = doc.id;
                                      }
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminDetailsUserPage(
                                                name: data[index]["name"],
                                                email: data[index]["email"],
                                                habilitado: data[index]
                                                    ["habilitado"],
                                                id: id,
                                              )),
                                    );
                                  },
                                  child: Text(data[index]["email"]),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Switch(
                                        value: data[index]["habilitado"],
                                        onChanged: (onChanged) {
                                          showDialog(
                                              context: context,
                                              builder: ((context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                      "Habilitar/Deshabilitar Usuario",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      "¿Esta seguro que desea Habilitar/Deshabilitar este usuario?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16.0),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: ButtonStyle(),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("NO"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          var id;
                                                          snapshot.data!.docs
                                                              .forEach((doc) {
                                                            if (data[index]
                                                                    ["email"] ==
                                                                doc["email"]) {
                                                              id = doc.id;
                                                            }
                                                          });
                                                          final userData =
                                                              <String, dynamic>{
                                                            "habilitado": !data[
                                                                    index]
                                                                ["habilitado"],
                                                            "fechaHoraActualizacion":
                                                                now,
                                                          };
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(id)
                                                              .update(userData);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("SI"),
                                                      ),
                                                    ],
                                                  )));
                                        })
                                  ],
                                ),
                              )
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
