import 'dart:convert';

List<PersonaDesaparecida> personasDesaparecidasFromJson(String str) =>
    List<PersonaDesaparecida>.from(
        json.decode(str).map((x) => PersonaDesaparecida.fromMap(x)));

class PersonaDesaparecida {
  PersonaDesaparecida({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.edad,
    this.sexo,
    required this.userId,
    required this.fotos
  });

  int? id;
  String nombre;
  String descripcion;
  String? edad;
  String? sexo;
  int userId;
  List<dynamic> fotos;

  factory PersonaDesaparecida.fromJson(String str) =>
      PersonaDesaparecida.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PersonaDesaparecida.fromMap(Map<String, dynamic> json) {

    
    return PersonaDesaparecida(
      id: json["id"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      edad: json["edad"],
      sexo: json["sexo"],
      userId: json["userId"],
      fotos: json["fotos"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "edad": edad,
        "sexo": sexo,
        "userId": userId,
        "fotos": fotos,
      };

  bool get isEmpty => id == 0 && nombre.isEmpty && descripcion.isEmpty;
}
