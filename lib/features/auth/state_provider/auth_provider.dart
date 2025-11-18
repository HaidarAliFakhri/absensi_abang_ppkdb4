import 'dart:developer';

import 'package:absensi_abang_ppkdb4/core/storage/local_storage.dart';
import 'package:absensi_abang_ppkdb4/features/auth/model/register_request.dart';
import 'package:absensi_abang_ppkdb4/features/auth/model/user_model.dart';
import 'package:flutter/material.dart';

import '../data/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  UserModel? currentUser;
  String? token;

  final AuthApi _api = AuthApi();

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      // RESULT DARI API: { "token": "...", "user": {...} }
      final result = await _api.login(email, password);

      if (result != null) {
        token = result["token"];

        // simpan token
        await LocalStorage.saveToken(token!);

        // parse user
        currentUser = UserModel.fromJson(
          result["user"] as Map<String, dynamic>,
        );

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      log("Login error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest req) async {
    isLoading = true;
    notifyListeners();

    try {
      // kirim request ke API
      final result = await _api.register(req.name, req.email, req.password);

      if (result != null) {
        token = result["token"];

        // simpan token
        await LocalStorage.saveToken(token!);

        // parse user
        currentUser = UserModel.fromJson(
          result["user"] as Map<String, dynamic>,
        );

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      log("Register error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    currentUser = null;
    token = null;
    LocalStorage.clearToken();
    notifyListeners();
  }
}
