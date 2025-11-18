import 'package:absensi_abang_ppkdb4/features/auth/view/home_screen.dart';
import 'package:absensi_abang_ppkdb4/features/auth/view/login_screen.dart';
// import 'package:absensi_abang_ppkdb4/features/auth/view/splashscreen.dart';
// import 'package:absensi_abang_ppkdb4/features/auth/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/state_provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
