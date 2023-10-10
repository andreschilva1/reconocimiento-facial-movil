import 'dart:convert';

class User {
  User({
    this.id,
    required this.nombre,
    required this.email,
    this.celular,
  });

  int? id;
  String nombre;
  String email;
  String? celular;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        nombre: json["nombre"],
        email: json["email"],
        celular: json["celular"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "email": email,
        "celular": celular,
      };

  bool get isEmpty => id == 0 && nombre.isEmpty && email.isEmpty;
  
  @override
  String toString() {
    // TODO: implement toString

    return 'id: $id, nombre: $nombre, email: $email, celular: $celular';
  }

}
