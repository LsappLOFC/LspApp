import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDetailsUserPage extends StatefulWidget {
  final email;
  final name;
  final habilitado;
  final id;
  const AdminDetailsUserPage(
      {Key? key, this.email, this.name, this.habilitado, this.id})
      : super(key: key);

  @override
  State<AdminDetailsUserPage> createState() => _AdminDetailsUserPageState();
}

class _AdminDetailsUserPageState extends State<AdminDetailsUserPage> {
  String getDate(date) {
    DateTime now = date.toDate();
    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return convertedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Sugerencias",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Recomendaciones",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0),
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {},
                child: const Text(
                  "USUARIO",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                bottom: 25.0,
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nombre:        ${widget.name}",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Text(
                      "Correo:          ${widget.email}",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  Text(
                    widget.habilitado
                        ? "Habilitado:    SI"
                        : "Habilitado:    NO",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("comments")
                          .where("type_comment", isEqualTo: "sugerencias")
                          .where("user_Id", isEqualTo: widget.id)
                          .snapshots(),
                      builder:
                          ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.hasData) {
                          List<dynamic> data = [];
                          snapshot.data!.docs.forEach((doc) {
                            final data3 = <String, dynamic>{
                              "comment": doc["comment"],
                              "estado_eliminado": doc["estado_eliminado"],
                              "estado_leido": doc["estado_leido"],
                              "fechaHoraActualizacion":
                                  doc["fechaHoraActualizacion"],
                              "fechaHoraRegistro": doc["fechaHoraRegistro"],
                              "type_comment": doc["type_comment"],
                              "id": doc.id,
                              "user_Id": doc["user_Id"],
                              "visto": doc["visto"],
                            };
                            data.add(data3);
                          });
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onLongPress: () async {
                                        final commentData = <String, dynamic>{
                                          "visto": !data[index]["visto"],
                                          "fechaHoraActualizacion": now,
                                        };
                                        if (data[index]["visto"] != true) {
                                          await FirebaseFirestore.instance
                                              .collection("comments")
                                              .doc(data[index]["id"])
                                              .update(commentData);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: data[index]["visto"]
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text("Sugerencia #${index + 1}"),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                data[index]["comment"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(getDate(data[index]
                                                    ["fechaHoraRegistro"])),
                                                Container(
                                                  child: data[index]["visto"]
                                                      ? Text("✓✓")
                                                      : Text("✓"),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        }
                        return Container();
                      })),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("comments")
                          .where("type_comment", isEqualTo: "recomendaciones")
                          .where("user_Id", isEqualTo: widget.id)
                          .snapshots(),
                      builder:
                          ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.hasData) {
                          List<dynamic> data = [];
                          snapshot.data!.docs.forEach((doc) {
                            final data3 = <String, dynamic>{
                              "comment": doc["comment"],
                              "estado_eliminado": doc["estado_eliminado"],
                              "estado_leido": doc["estado_leido"],
                              "fechaHoraActualizacion":
                                  doc["fechaHoraActualizacion"],
                              "fechaHoraRegistro": doc["fechaHoraRegistro"],
                              "type_comment": doc["type_comment"],
                              "id": doc.id,
                              "user_Id": doc["user_Id"],
                              "visto": doc["visto"],
                            };
                            data.add(data3);
                          });
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onLongPress: () async {
                                        final commentData = <String, dynamic>{
                                          "visto": !data[index]["visto"],
                                          "fechaHoraActualizacion": now,
                                        };
                                        if (data[index]["visto"] != true) {
                                          await FirebaseFirestore.instance
                                              .collection("comments")
                                              .doc(data[index]["id"])
                                              .update(commentData);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: data[index]["visto"]
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text("Recomendacion #${index + 1}"),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                data[index]["comment"],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                ),
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(getDate(data[index]
                                                    ["fechaHoraRegistro"])),
                                                Container(
                                                  child: data[index]["visto"]
                                                      ? Text("✓✓")
                                                      : Text("✓"),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        }
                        return Container();
                      })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
