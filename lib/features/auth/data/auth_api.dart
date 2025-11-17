import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "https://appabsensi.mobileprojp.com/";

  Future<String?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["token"];
    } else {
      return null;
    }
  }

  Future<String?> register(String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return data["token"];
    } else {
      return null;
    }
  }
}
