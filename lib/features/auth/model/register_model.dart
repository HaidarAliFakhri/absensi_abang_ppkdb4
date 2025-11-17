import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String jenisKelamin;
  final String profilePhoto;
  final int batchId;
  final int trainingId;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.jenisKelamin,
    required this.profilePhoto,
    required this.batchId,
    required this.trainingId,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    jenisKelamin: json["jenis_kelamin"],
    profilePhoto: json["profile_photo"] ?? "",
    batchId: json["batch_id"],
    trainingId: json["training_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "batch_id": batchId,
    "training_id": trainingId,
  };
}
