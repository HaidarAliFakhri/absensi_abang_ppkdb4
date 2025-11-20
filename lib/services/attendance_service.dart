// package:absensi_abang_ppkdb4/services/attendance_service.dart

import 'dart:convert';

import 'package:absensi_abang_ppkdb4/app/constants/endpoint.dart';
import 'package:absensi_abang_ppkdb4/models/user_model.dart';
import 'package:absensi_abang_ppkdb4/services/preference_handler.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static Future<String?> _getToken() async {
    return await PreferenceHandler.getToken();
  }

  // Helper untuk permintaan POST yang membutuhkan otorisasi (token)
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

  // Helper untuk permintaan GET yang membutuhkan otorisasi (token)
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

  // 1. Ambil Profil Pengguna
  static Future<UserModel?> getProfile() async {
    try {
      final res = await _getAuthorized(Endpoint.profile);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // Pastikan key 'data' ada, jika tidak, anggap body adalah data user
        return UserModel.fromJson(data['data'] ?? data);
      }

      // 🔥 KUNCI DEBUGGING: Cetak BODY respons GAGAL dari server
      print("🚨 RESPONSE BODY GAGAL (${res.statusCode}): ${res.body}");

      if (res.statusCode == 401) {
        print(
          "Error fetching profile: 401 Unauthorized. Token rejected by server. Clearing stored session.",
        );
        // Hapus token dan status login untuk memaksa logout
        await PreferenceHandler.removeToken();
        await PreferenceHandler.removeLogin();
      } else {
        print(
          "Error fetching profile: Server responded with status ${res.statusCode}",
        );
      }
      return null;
    } catch (e) {
      // Log untuk kegagalan koneksi atau pengecualian token missing
      print("Error fetching profile: Connection/Auth failed: $e");
      return null;
    }
  }

  // 2. Absen Masuk (Check-In)
  static Future<String> checkIn(double lat, double lng) async {
    try {
      final res = await _postAuthorized(Endpoint.checkIn, {
        "latitude": lat,
        "longitude": lng,
      });

      final body = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body["message"] ?? "Absen Masuk Berhasil!";
      } else {
        return body["message"] ??
            "Absen Masuk Gagal (Status: ${res.statusCode})";
      }
    } catch (e) {
      print("Check-in Error: $e");
      return "Terjadi kesalahan koneksi atau autentikasi. Pastikan Anda sudah login.";
    }
  }

  // 3. Absen Pulang (Check-Out)
  static Future<String> checkOut(double lat, double lng) async {
    try {
      final res = await _postAuthorized(Endpoint.checkOut, {
        "latitude": lat,
        "longitude": lng,
      });

      final body = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body["message"] ?? "Absen Pulang Berhasil!";
      } else {
        return body["message"] ??
            "Absen Pulang Gagal (Status: ${res.statusCode})";
      }
    } catch (e) {
      print("Check-out Error: $e");
      return "Terjadi kesalahan koneksi atau autentikasi. Pastikan Anda sudah login.";
    }
  }

  // 4. Ambil Absensi Hari Ini
  static Future<Map<String, dynamic>?> getTodayPresence() async {
    try {
      final res = await _getAuthorized(Endpoint.todayPresence);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['data'] is Map && data['data'].isNotEmpty) {
          return Map<String, dynamic>.from(data['data']);
        }
        return null;
      }
      return null;
    } catch (e) {
      print("Error fetching today's presence: $e");
      return null;
    }
  }
}
