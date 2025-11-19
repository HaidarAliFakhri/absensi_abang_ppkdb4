import 'dart:convert';

import 'package:absensi_abang_ppkdb4/models/batch_model.dart';
import 'package:absensi_abang_ppkdb4/models/training_model.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = "https://absensib1.mobileprojp.com/api";

  // GET TRAINING
  static Future<List<Trainings>> getTraining() async {
    final url = Uri.parse("$baseUrl/training");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List).map((e) => Trainings.fromJson(e)).toList();
    }
    return [];
  }

  // GET BATCH
  static Future<List<Batch>> getBatch() async {
    final url = Uri.parse("$baseUrl/batch");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List).map((e) => Batch.fromJson(e)).toList();
    }
    return [];
  }

  // REGISTER
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required int trainingId,
    required int batchId,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "jenis_kelamin": gender,
          "training_id": trainingId,
          "batch_id": batchId,
          "profile_photo": "",
        }),
      );

      print("REGISTER STATUS: ${res.statusCode}");
      print("REGISTER BODY: ${res.body}");

      // Sukses kalau status 200 atau 201
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return false;
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    // Kembalikan JSON apa adanya
    return {"status": res.statusCode, "body": jsonDecode(res.body)};
  }
}
