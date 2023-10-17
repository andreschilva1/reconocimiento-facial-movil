import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sw2_parcial1_movil/models/persona_desaparecida.dart';
import 'package:sw2_parcial1_movil/services/api_service.dart' as api_service;
import 'package:http/http.dart' as http;

class ReconocimientoService extends ChangeNotifier {
  bool isLoading = false;
  static const  String _baseUrl = api_service.baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  Future<PersonaDesaparecida?> reconocerPersona( {required File imageFile}) async {

  isLoading = true;
  notifyListeners();

  String? token = await _storage.read(key: 'token');
  if (token == null) {
    print('No hay token');
    return null;
  }
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$_baseUrl/api/reconocerPersona'), // Cambia a tu URL
  );

  request.headers.addAll(headers);
  request.files
      .add(await http.MultipartFile.fromPath('imagen', imageFile.path));

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      var jsonResponse = await response.stream.bytesToString();
      var personaDesaparecida = PersonaDesaparecida.fromMap(json.decode(jsonResponse));
        return personaDesaparecida;
    } else {
      print(
          'Error. Código de estado: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
  }finally{
    isLoading = false;
    notifyListeners();
  }
}

}