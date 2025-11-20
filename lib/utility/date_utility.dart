import 'package:intl/intl.dart';

class DateUtility {
  /// Mendapatkan tanggal hari ini dalam format bahasa Indonesia (e.g., "Kamis, 20 November 2025").
  static String getTodayDate() {
    // Menggunakan locale 'id_ID' untuk bahasa Indonesia
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return formatter.format(DateTime.now());
  }
}
