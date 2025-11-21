class Endpoint {
  // BASE URL API yang sebenarnya
  static const String BASE_URL = "https://appabsensi.mobileprojp.com/api";
  // Auth & User Management
  static const String register = "$BASE_URL/register";
  static const String login = "$BASE_URL/login";
  static const String profile = "$BASE_URL/profile";
  static const String updateProfilePhoto = "$BASE_URL/profile/photo";
  // Data Reference
  static const String trainings = "$BASE_URL/trainings";
  static const String batches = "$BASE_URL/batches";
  // Attendance (Absensi)
  static const String checkIn = "$BASE_URL/absen/check-in";
  static const String checkOut = "$BASE_URL/absen/check-out";
  static const String izin = "$BASE_URL/izin";
  static const String todayPresence = "$BASE_URL/absen/today";
  static const String historyAbsen = "$BASE_URL/absen/history";
  static const String presenceStats = "$BASE_URL/absen/stats";
  static const String deleteAbsen = "$BASE_URL/absen";
  static const String todayAttendance = "$BASE_URL/absen/today";
}
