// lib/services/api.dart

import 'dart:convert';

import 'package:absensi_abang_ppkdb4/app/constants/endpoint.dart';
import 'package:absensi_abang_ppkdb4/models/batch_model.dart';
import 'package:absensi_abang_ppkdb4/models/registermodels.dart';
import 'package:absensi_abang_ppkdb4/models/training_model.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  // GET TRAINING (Sudah Static)
  static Future<List<Trainings>> getTraining() async {
    final url = Uri.parse(Endpoint.trainings);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List).map((e) => Trainings.fromJson(e)).toList();
    }
    return [];
  }

  // GET BATCH (Sudah Static)
  static Future<List<Batch>> getBatch() async {
    final url = Uri.parse(Endpoint.batches);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List).map((e) => Batch.fromJson(e)).toList();
    }
    return [];
  }

  // REGISTER (Sudah Static dan menerima RegisterModel)
  static Future<bool> register(RegisterModel data) async {
    final url = Uri.parse(Endpoint.register);

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      print("REGISTER RESPONSE: ${res.body}");

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return {"status": res.statusCode, "body": jsonDecode(res.body)};
  }
}
