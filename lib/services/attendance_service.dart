// package:absensi_abang_ppkdb4/services/attendance_service.dart

import 'dart:convert';

import 'package:absensi_abang_ppkdb4/app/constants/endpoint.dart';
import 'package:absensi_abang_ppkdb4/models/absensi_model.dart';
import 'package:absensi_abang_ppkdb4/models/user_model.dart';
import 'package:absensi_abang_ppkdb4/services/preference_handler.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  // ==============================
  // TOKEN HANDLER
  // ==============================
  static Future<String?> _getToken() async {
    return await PreferenceHandler.getToken();
  }

  // ==============================
  // POST with Authorization
  // ==============================
  static Future<http.Response> _postAuthorized(
    String url,
    Map<String, dynamic> body,
  ) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token missing. Please login again.");
    }

    return http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  // ==============================
  // GET with Authorization
  // ==============================
  static Future<http.Response> _getAuthorized(String url) async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token missing. Please login again.");
    }

    return http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // ==============================
  // 1. GET USER PROFILE
  // ==============================
  static Future<UserModel?> getProfile() async {
    try {
      final res = await _getAuthorized(Endpoint.profile);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return UserModel.fromJson(data['data'] ?? data);
      }

      print("🚨 PROFILE ERROR (${res.statusCode}): ${res.body}");

      if (res.statusCode == 401) {
        await PreferenceHandler.removeToken();
        await PreferenceHandler.removeLogin();
      }

      return null;
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }

  // ==============================
  // 2. CHECK-IN (ABSEN MASUK)
  // ==============================
  static Future<String> checkIn(double lat, double lng) async {
    try {
      final res = await _postAuthorized(Endpoint.checkIn, {
        "latitude": lat,
        "longitude": lng,
      });

      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body["message"] ?? "Absen Masuk Berhasil!";
      }

      return body["message"] ?? "Absen Masuk Gagal (Status: ${res.statusCode})";
    } catch (e) {
      print("Check-in Error: $e");
      return "Terjadi kesalahan koneksi atau autentikasi. Pastikan Anda sudah login.";
    }
  }

  // ==============================
  // 3. CHECK-OUT (ABSEN PULANG)
  // ==============================
  static Future<String> checkOut(double lat, double lng) async {
    try {
      final res = await _postAuthorized(Endpoint.checkOut, {
        "latitude": lat,
        "longitude": lng,
      });

      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body["message"] ?? "Absen Pulang Berhasil!";
      }

      return body["message"] ??
          "Absen Pulang Gagal (Status: ${res.statusCode})";
    } catch (e) {
      print("Check-out Error: $e");
      return "Terjadi kesalahan koneksi atau autentikasi. Pastikan Anda sudah login.";
    }
  }

  // ==============================
  // 4. GET TODAY'S ATTENDANCE
  // ==============================
  static Future<AbsensiModel?> getTodayPresence() async {
    try {
      final res = await _getAuthorized(Endpoint.todayPresence);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data["data"] != null && data["data"].isNotEmpty) {
          return AbsensiModel.fromJson(data["data"]);
        }

        return null;
      }

      print("Gagal ambil presensi hari ini: ${res.statusCode}");
      return null;
    } catch (e) {
      print("Error fetching today's presence: $e");
      return null;
    }
  }

  // ==============================
  // 5. AJUKAN IZIN
  // ==============================
  static Future<String> izin(String keterangan) async {
    try {
      final res = await _postAuthorized(Endpoint.izin, {
        "keterangan": keterangan,
      });

      final body = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body["message"] ?? "Pengajuan izin berhasil!";
      }

      return body["message"] ??
          "Pengajuan izin gagal (Status: ${res.statusCode})";
    } catch (e) {
      print("Izin Error: $e");
      return "Terjadi kesalahan saat mengajukan izin. Pastikan Anda sudah login.";
    }
  }
}
