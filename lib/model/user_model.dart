import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? _uid;
  String? _name;
  String? _email;
  String? _imageUrl;
  bool? _eliminado;
  DateTime? _fechaHoraRegistro;
  DateTime? _fechaHoraActualizacion;
  bool? _habilitado;
  String? _rol;

  set user(User? user) {
    _uid = user != null ? user.uid : null;
    _name = user != null ? user.displayName : null;
    _email = user != null ? user.email : null;
    _imageUrl = user != null ? user.photoURL : null;
    _eliminado = true;
    _fechaHoraRegistro = null;
    _fechaHoraActualizacion = null;
    _habilitado = true;
  }

  String? get uid => _uid;

  String? get name => _name;

  String? get email => _email;

  String? get imageUrl => _imageUrl;

  bool? get eliminado => _eliminado;

  DateTime? get fechaHoraRegistro => _fechaHoraRegistro;

  DateTime? get fechaHoraActualizacion => _fechaHoraActualizacion;

  bool? get habilitado => _habilitado;

  String? get rol => _rol;
}
