import 'package:absensi_abang_ppkdb4/features/auth/model/batch_model.dart';
import 'package:absensi_abang_ppkdb4/features/auth/model/training_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final int batchId;
  final int trainingId;
  final String jenisKelamin;
  final String profilePhoto;
  final String? onesignalPlayerId;

  final BatchModel? batch;
  final TrainingModel? training;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.batchId,
    required this.trainingId,
    required this.jenisKelamin,
    required this.profilePhoto,
    this.onesignalPlayerId,
    this.batch,
    this.training,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      batchId: int.tryParse(json["batch_id"].toString()) ?? 0,
      trainingId: int.tryParse(json["training_id"].toString()) ?? 0,
      jenisKelamin: json["jenis_kelamin"] ?? "",
      profilePhoto: json["profile_photo"] ?? "",
      onesignalPlayerId: json["onesignal_player_id"],

      // FIX TERPENTING
      batch: (json["batch"] is Map) ? BatchModel.fromJson(json["batch"]) : null,
      training: (json["training"] is Map)
          ? TrainingModel.fromJson(json["training"])
          : null,
    );
  }
}
