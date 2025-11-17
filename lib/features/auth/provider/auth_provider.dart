// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:absensi_abang_ppkdb4/features/auth/model/register_model.dart';
import 'package:absensi_abang_ppkdb4/core/network/token_storage.dart';
import 'package:flutter/material.dart';

import '../data/auth_api.dart';
import '../model/register_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final AuthApi _api = AuthApi();

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final token = await _api.login(email, password);

    isLoading = false;
    notifyListeners();

    if (token != null) {
      await TokenStorage.saveToken(token);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(RegisterModel data) async {
    isLoading = true;
    notifyListeners();

    final token = await _api.register(data.name, data.email, data.password);

    isLoading = false;
    notifyListeners();

    if (token != null) {
      await TokenStorage.saveToken(token);
      return true;
    } else {
      return false;
    }
  }
}
