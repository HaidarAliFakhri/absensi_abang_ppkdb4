import 'dart:convert';
import 'dart:developer';

import 'package:absensi_abang_ppkdb4/app/constants/api_endpoints.dart';
import 'package:absensi_abang_ppkdb4/features/auth/model/batch_model.dart';
import 'package:absensi_abang_ppkdb4/features/auth/model/training_model.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final client = http.Client();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse(Endpoint.login);

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );

    log("LOGIN RESPONSE (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody["data"];
    } else {
      return null;
    }
  }
}

Future<Map<String, dynamic>?> register(
  String name,
  String email,
  String password,
) async {
  final response = await http.post(
    Uri.parse(Endpoint.register),
    body: {"name": name, "email": email, "password": password},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}

class TrainingAPI {
  static Future<List<TrainingModelData>> getTrainings() async {
    final url = Uri.parse(Endpoint.trainings);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainings: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List data = jsonBody['data'] as List;
      return data.map((e) => TrainingModelData.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data pelatihan");
    }
  }

  static Future<List<BatchModel>> getTrainingBatches() async {
    final url = Uri.parse(Endpoint.trainingBatches);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainingBatches: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List data = jsonBody['data'] as List;
      return data.map((e) => BatchModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data batch pelatihan");
    }
  }
}
