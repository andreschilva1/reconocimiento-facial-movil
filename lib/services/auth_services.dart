import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sw2_parcial1_movil/models/user.dart';
import 'package:sw2_parcial1_movil/services/api_service.dart' as api_service;

class AuthService extends ChangeNotifier {
  static const String _baseUrl = api_service.baseUrl;
  static User? user;
  bool isLoading = false;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    logout();
    isLoading = true;
    notifyListeners();

    const url = '$_baseUrl/api/login';

    final response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      user = User.fromJson(response.body);
  
      await storageWrite(token, user?.id, user!.email, user!.nombre,
          user?.celular);
     
     
      print('success login');
     
      isLoading = false;
      notifyListeners();
      
      return true;
    
    } else {
      isLoading = false;
      notifyListeners();
      print('Failed to login');
      return false;
      //throw Exception('Failed to login');
    }
    

  }

  Future<bool> register(String nombre, String email, String password, String? celular) async {
    isLoading = true;
    notifyListeners();

    const url = '$_baseUrl/api/register';

    final response = await http.post(Uri.parse(url), body: {
      'nombre': nombre,
      'email': email,
      'password': password,
      'celular': celular,
    });

    print(response.body);

    if (response.statusCode == 201) {
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      notifyListeners();
      print('Failed to register');
      return false;
      //throw Exception('Failed to register');
    }
  }

  Future<bool> checkAuth() async {
    final String? token = await getToken();
    print(token);
    if (token == null) {
      return false;
    }
    const url = '$_baseUrl/api/user';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': token,
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      await _storage.delete(key: 'token');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<String?> getToken() async{
    return await _storage.read(key: 'token');
  }

  Future storageWrite(String idToken , int? id , String email, String nombre, String? celular) async {
    await _storage.write(key: 'token', value: idToken);
    await _storage.write(key: 'id', value: id.toString() );
    await _storage.write(key: 'nombre', value: nombre);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'celular', value: celular);
  }

  Future<User> readUser() async {
    final id = await _storage.read(key: 'id');
    final nombre = await _storage.read(key: 'nombre');
    final email = await _storage.read(key: 'email');
    final celular = await _storage.read(key: 'celular');

    return User(
      id: int.tryParse(id ?? ''),
      nombre: nombre ?? '',
      email: email ?? '',
      celular: celular ?? '',
    );
  }
}
