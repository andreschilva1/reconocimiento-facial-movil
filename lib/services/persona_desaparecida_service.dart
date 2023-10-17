import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sw2_parcial1_movil/models/persona_desaparecida.dart';
import 'package:sw2_parcial1_movil/services/api_service.dart' as api_service;
import 'package:http/http.dart' as http;

class PersonaDesaparecidaService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const  String _baseUrl = api_service.baseUrl;
  bool isLoading = false;
  
  Future<List<PersonaDesaparecida>> getpersonasDesaparecidas() async {
    try {
      final response = await api_service.get('api/personasDesaparecidas');
      print(response.body);
      if (response.statusCode == 200) {
        final List<PersonaDesaparecida> personasDesaparecidas = personasDesaparecidasFromJson(response.body);
        return personasDesaparecidas;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw "No se pudo cargar las personas desaparecidas";
    }
  }

  Future<List<PersonaDesaparecida>> getMispersonasDesaparecidas() async {
    try {
      final response = await api_service.get('api/misPersonasDesaparecidas');
      ///print(response.body);
      if (response.statusCode == 200) {
        final List<PersonaDesaparecida> personasDesaparecidas = personasDesaparecidasFromJson(response.body);
        return personasDesaparecidas;
      } else {
        return List.empty();
      }
    } catch (e) {
      throw "No se pudo cargar las personas desaparecidas";
    }
  }

Future<void> crearPesonaDesaparecida(
    {required File imageFile,
    String nombre = '',
    String descripcion = '',
    String edad = '',
    String sexo = ''}) async {

  isLoading = true;
  notifyListeners();

  String? token = await _storage.read(key: 'token');
  if (token == null) {
    print('No hay token');
    return;
  }
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$_baseUrl/api/subirImagen'), // Cambia a tu URL
  );

  request.headers.addAll(headers);
  request.files
      .add(await http.MultipartFile.fromPath('imagen', imageFile.path));
      
  request.fields['nombre'] = nombre;
  request.fields['descripcion'] = descripcion;
  request.fields['edad'] = edad;
  request.fields['sexo'] = sexo;

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(
          'Error al subir la imagen. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
  }finally{
    isLoading = false;
    notifyListeners();
  }
}

Future<bool> deletePersonaDesaparecida(String id) async{
  try {
      final response = await api_service.delete('api/deletePersonaDesaparecida',id);
      ///print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw "No se pudo cargar las personas desaparecidas ";
    }
}


}
