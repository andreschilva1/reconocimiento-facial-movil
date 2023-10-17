import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


  const String baseUrl = 'http://192.168.0.110:3000';
  const  FlutterSecureStorage _storage =  FlutterSecureStorage();

 
  Future<http.Response> get(String path) async {
    final token = await _storage.read(key: 'token');
    final url = '$baseUrl/$path';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': '$token'});
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'token');
    final url = '$baseUrl/$path';
    final response = await http.post(Uri.parse(url),
        headers: {'Authorization': '$token'}, body: json.encode(body));
    return response;
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'token');
    final url = '$baseUrl/$path';
    final response = await http.put(Uri.parse(url),
        headers: {'Authorization': '$token'}, body: json.encode(body));
    return response;
  }

  Future<http.Response> delete(String path, String id) async {
    final token = await _storage.read(key: 'token');
    final url = '$baseUrl/$path';
    final response = await http
        .delete(Uri.parse(url), headers: {'Authorization': '$token'},body: {'id': id});
    return response;
  }

