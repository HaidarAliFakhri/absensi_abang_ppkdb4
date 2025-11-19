import 'package:absensi_abang_ppkdb4/screens/login_screen.dart';
// import 'package:absensi_abang_ppkdb4/screens/mainpage.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      // routes: {
      // '/login': (context) => const LoginScreen(),
      // '/home': (context) => const HomeScreen(),
      // },
    );
  }
}
