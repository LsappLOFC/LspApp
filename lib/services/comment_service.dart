import 'package:cloud_firestore/cloud_firestore.dart';

final commentDb = FirebaseFirestore.instance.collection("comentarios");

class CommentService {
  Future createComment(String comment, String type, String userId) async {
    await commentDb
        .doc()
        .set({
          "comentario": comment,
          "tipo": type,
          "idUsuario": userId,
          "fechaHoraRegistro": DateTime.now(),
          "fechaHoraActualizacion": DateTime.now(),
          "eliminado": false,
          "leido": false,
        })
        .then((value) => null)
        .catchError((error) {});
  }
}
