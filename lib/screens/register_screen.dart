// lib/screens/register_screen.dart

import 'package:absensi_abang_ppkdb4/models/registermodels.dart';
import 'package:absensi_abang_ppkdb4/services/api.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  List<Map<String, dynamic>> batchList = [];
  List<Map<String, dynamic>> trainingList = [];

  int? selectedBatch;
  int? selectedTraining;
  String? selectedGender;

  bool loading = true;
  bool _isPasswordVisible = false; // 👈 State untuk visibilitas password

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final batches = await AuthApi.getBatch();
    final trainings = await AuthApi.getTraining();

    setState(() {
      batchList = batches.map((e) => {"id": e.id, "label": e.batchKe}).toList();
      trainingList = trainings
          .map((e) => {"id": e.id, "label": e.title})
          .toList();
      loading = false;
    });
  }

  void doRegister() async {
    if (selectedBatch == null ||
        selectedTraining == null ||
        selectedGender == null ||
        nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data!")),
      );
      return;
    }

    final registerData = RegisterModel(
      name: nameC.text,
      email: emailC.text,
      password: passC.text,
      gender: selectedGender!,
      trainingId: selectedTraining!,
      batchId: selectedBatch!,
    );

    final res = await AuthApi.register(registerData);

    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Berhasil! Silakan masuk.")),
      );
      // Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Gagal. Coba lagi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            // 💡 FIELD PASSWORD DENGAN VISIBILITY TOGGLE
            TextField(
              controller: passC,
              // Menggunakan _isPasswordVisible untuk menyembunyikan/menampilkan teks
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                // 👈 Tambahkan IconButton untuk toggle visibility
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Update state saat ikon diklik
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DROPDOWN JENIS KELAMIN
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Jenis Kelamin"),
              initialValue: selectedGender,
              items: const [
                DropdownMenuItem(value: "L", child: Text("Laki-Laki")),
                DropdownMenuItem(value: "P", child: Text("Perempuan")),
              ],
              onChanged: (v) {
                setState(() => selectedGender = v);
              },
            ),

            const SizedBox(height: 20),

            // DROPDOWN BATCH
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Pilih Batch"),
              initialValue: selectedBatch,
              items: batchList
                  .map(
                    (e) => DropdownMenuItem<int>(
                      value: e["id"],
                      child: Text(e["label"]),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => selectedBatch = v);
              },
            ),

            const SizedBox(height: 20),

            // DROPDOWN TRAINING
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Pilih Training"),
              initialValue: selectedTraining,
              items: trainingList
                  .map(
                    (e) => DropdownMenuItem<int>(
                      value: e["id"],
                      child: Text(e["label"]),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => selectedTraining = v);
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: doRegister,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
