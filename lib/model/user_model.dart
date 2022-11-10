import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isEnabled;
  String? type;

  UserModel({
    this.name,
    this.email,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isEnabled,
    this.type,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['nombre'],
      email: data?['correo'],
      imageUrl: data?['imagen'],
      createdAt: data?['fechaHoraRegistro'],
      updatedAt: data?['fechaHoraActualizacion'],
      isEnabled: data?['habilitado'],
      type: data?['tipo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "nombre": name,
      if (email != null) "correo": email,
      if (imageUrl != null) "imagen": imageUrl,
      if (createdAt != null) "fechaHoraRegistro": createdAt,
      if (updatedAt != null) "fechaHoraActualizacion": updatedAt,
      if (isEnabled != null) "habilitado": isEnabled,
      if (type != null) "tipo": type
    };
  }
}
