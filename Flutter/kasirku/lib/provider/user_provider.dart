import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:sop_app/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sop_app/my_env.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<bool>? register(User user) async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/register');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode(user.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        bool? status = responseData['status'];
        if (status ?? false) {
          return true;
        }
      }
      throw responseData['message'] ?? 'Gagal mendaftarkan pengguna!';
    } catch (e) {
      throw 'Gagal mendaftarkan pengguna!';
    }
  }

  Future<bool>? login(String email, String password) async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/login');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        bool? status = responseData['status'];
        if (status ?? false) {
          String token = responseData['data']['token'];
          MyEnv.token = "Bearer $token";
          _user = User.fromJson(responseData['data']['user']);

          final FlutterSecureStorage secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'api_token', value: token);

          notifyListeners();
          return true;
        }
      }
      throw 'Proses masuk gagal!';
    } catch (e) {
      throw 'Proses masuk gagal!';
    }
  }
}
