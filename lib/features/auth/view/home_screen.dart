import 'package:absensi_abang_ppkdb4/core/storage/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../state_provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Ambil user yang sedang login
    final UserModel? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LocalStorage.clearToken();
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: user == null
          ? const Center(child: Text("User tidak ditemukan"))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selamat Datang 👋",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  _infoTile("Nama", user.name),
                  _infoTile("Email", user.email),
                  _infoTile("Jenis Kelamin", user.jenisKelamin),
                  _infoTile("Batch ID", user.batchId?.toString()),
                  _infoTile("Training ID", user.trainingId?.toString()),
                  _infoTile("Profile Photo", user.profilePhoto ?? "-"),
                ],
              ),
            ),
    );
  }

  // Widget helper untuk membuat item informasi
  Widget _infoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? "-"),
        ],
      ),
    );
  }
}
