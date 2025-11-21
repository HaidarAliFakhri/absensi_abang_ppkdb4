import 'package:absensi_abang_ppkdb4/services/api.dart';
import 'package:absensi_abang_ppkdb4/services/preference_handler.dart';
import 'package:absensi_abang_ppkdb4/widgets/navigation.dart';
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

    // Asumsi: AuthApi.login akan mengembalikan Map, termasuk token di 'body'
    final result = await AuthApi.login(
      email: emailC.text,
      password: passC.text,
    );

    setState(() => loading = false);

    final status = result["status"];
    final body = result["body"];

    if (status == 200) {
      // 🔥 PERBAIKAN UTAMA: Akses token dari body["data"]["token"]
      // Kita perlu mengekstrak 'data' sebagai Map terlebih dahulu.
      final data = body["data"];

      String? token;
      if (data is Map<String, dynamic>) {
        // Coba ambil dari data['token']
        token = data["token"] as String?;
      }

      if (token != null && token.isNotEmpty) {
        // PERBAIKAN UTAMA: AWAIT penyimpanan token & status login
        await PreferenceHandler.saveToken(token);
        await PreferenceHandler.saveLogin(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Login berhasil!")),
        );

        /// Setelah login sukses & token TER-AWAIT, pindah ke DashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
        );
      } else {
        // Token kosong/null
        print(
          "🚨 Peringatan: Respons API 200 OK, tetapi key 'data.token' kosong. Respons Body: $body",
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Login berhasil, namun Token tidak ditemukan di respons API.",
            ),
          ),
        );
      }
    } else {
      // Login gagal (misalnya status 401 Unauthorized)
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
