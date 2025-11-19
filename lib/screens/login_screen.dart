import 'package:absensi_abang_ppkdb4/screens/main_screen.dart';
import 'package:absensi_abang_ppkdb4/services/api.dart';
import 'package:flutter/material.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool loading = false;
  bool showPassword = false;

  Future<void> doLogin() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    final result = await AuthApi.login(
      email: emailC.text,
      password: passC.text,
    );

    setState(() => loading = false);

    final status = result["status"];
    final body = result["body"];

    if (status == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(body["message"])));

      /// 🔥 Setelah login sukses → pindah ke MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(body["message"] ?? "Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passC,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => showPassword = !showPassword);
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : doLogin,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );

                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Register berhasil, silakan login"),
                      ),
                    );
                  }
                },
                child: const Text("Belum punya akun? Daftar di sini"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
