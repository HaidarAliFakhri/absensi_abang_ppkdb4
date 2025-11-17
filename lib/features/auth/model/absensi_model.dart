// To parse this JSON data, do
//
//     final absensi = absensiFromJson(jsonString);

import 'dart:convert';

Absensi absensiFromJson(String str) => Absensi.fromJson(json.decode(str));

String absensiToJson(Absensi data) => json.encode(data.toJson());

class Absensi {
  String email;
  String password;

  Absensi({required this.email, required this.password});

  factory Absensi.fromJson(Map<String, dynamic> json) =>
      Absensi(email: json["email"], password: json["password"]);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
