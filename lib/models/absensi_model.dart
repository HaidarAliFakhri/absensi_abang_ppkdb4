class AbsensiModel {
  final int? id;
  final String attendanceDate;
  final String? checkInTime;
  final double? checkInLat;
  final double? checkInLng;
  final String? checkInLocation;
  final String? checkInAddress;
  final String status;
  final String? alasanIzin;

  AbsensiModel({
    this.id,
    required this.attendanceDate,
    this.checkInTime,
    this.checkInLat,
    this.checkInLng,
    this.checkInLocation,
    this.checkInAddress,
    required this.status,
    this.alasanIzin,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      id: json["id"],
      attendanceDate: json["attendance_date"],
      checkInTime: json["check_in_time"],
      checkInLat: json["check_in_lat"]?.toDouble(),
      checkInLng: json["check_in_lng"]?.toDouble(),
      checkInLocation: json["check_in_location"],
      checkInAddress: json["check_in_address"],
      status: json["status"],
      alasanIzin: json["alasan_izin"],
    );
  }
}
