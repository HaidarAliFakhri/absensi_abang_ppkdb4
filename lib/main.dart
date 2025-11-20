import 'package:absensi_abang_ppkdb4/screens/login_screen.dart'; // Ganti dengan Home/Splash Screen Anda
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // 🔥 Wajib di-import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Abang PPKDB4',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Anda mungkin perlu mengganti ini dengan Splash/Landing Screen yang memeriksa status login
      home: const LoginScreen(),
    );
  }
}
