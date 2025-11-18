import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  String? message;
  RegisterUserData? data; // data user yang berhasil register

  RegisterModel({this.message, this.data});

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    message: json["message"],
    data: json["data"] == null ? null : RegisterUserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

/// DATA USER SETELAH REGISTRASI
class RegisterUserData {
  int? id;
  String? name;
  String? email;
  String? jenisKelamin;
  String? profilePhoto;
  int? batchId;
  int? trainingId;
  String? createdAt;
  String? updatedAt;

  RegisterUserData({
    this.id,
    this.name,
    this.email,
    this.jenisKelamin,
    this.profilePhoto,
    this.batchId,
    this.trainingId,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisterUserData.fromJson(Map<String, dynamic> json) =>
      RegisterUserData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        jenisKelamin: json["jenis_kelamin"],
        profilePhoto: json["profile_photo"],
        batchId: json["batch_id"],
        trainingId: json["training_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "batch_id": batchId,
    "training_id": trainingId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
