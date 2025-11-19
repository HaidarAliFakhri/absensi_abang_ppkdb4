import 'dart:convert';

import 'package:http/http.dart' as http;

class AbsensiApi {
  static const baseUrl = "https://absensib1.mobileprojp.com/api";

  static Future<Map<String, dynamic>?> checkIn({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final url = Uri.parse("$baseUrl/absen/check-in");

    final res = await http.post(
      url,
      body: {
        "attendance_date": date,
        "check_in": time,
        "check_in_lat": lat.toString(),
        "check_in_lng": lng.toString(),
        "check_in_address": address,
        "status": "masuk",
      },
    );

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>?> checkOut({
    required String date,
    required String time,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final url = Uri.parse("$baseUrl/absen/check-out");

    final res = await http.post(
      url,
      body: {
        "attendance_date": date,
        "check_out": time,
        "check_out_lat": lat.toString(),
        "check_out_lng": lng.toString(),
        "check_out_address": address,
      },
    );

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>?> izin({
    required String date,
    required String alasan,
  }) async {
    final url = Uri.parse("$baseUrl/izin");

    final res = await http.post(
      url,
      body: {"date": date, "alasan_izin": alasan},
    );

    return jsonDecode(res.body);
  }
}
