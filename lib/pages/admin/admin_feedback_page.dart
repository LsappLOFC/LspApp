import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({Key? key}) : super(key: key);

  @override
  State<AdminFeedbackPage> createState() => _AdminFeedbackPageState();
}

class _AdminFeedbackPageState extends State<AdminFeedbackPage> {
  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("comments")
                          .where("type_comment", isEqualTo: "sugerencias")
                          .snapshots(),
                      builder:
                          ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.hasData) {
                          List<dynamic> data = [];
                          snapshot.data!.docs.forEach((doc) {
                            data.add(doc.data());
                          });
                          print(data);
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onDoubleTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Text("Sugerencia #1"),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: GestureDetector(
                                                onDoubleTap: () {},
                                                child: Text(
                                                  data[index]["comment"],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("21/09/2022"),
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
                          .snapshots(),
                      builder:
                          ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.hasData) {
                          List<dynamic> data = [];
                          snapshot.data!.docs.forEach((doc) {
                            data.add(doc.data());
                          });
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: InkWell(
                                      onDoubleTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text("Recomendacion #1"),
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
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("21/09/2022"),
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
