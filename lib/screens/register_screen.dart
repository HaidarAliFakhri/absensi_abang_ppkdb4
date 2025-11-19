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

  String? gender;
  int? selectedTraining;
  int? selectedBatch;

  bool loading = false;
  bool showPassword = false;

  final List<Map<String, dynamic>> trainingList = [
    {"id": 1, "label": "Web Developer"},
    {"id": 2, "label": "Teknik Komputer"},
    {"id": 3, "label": "Jaringan Komputer"},
    {"id": 4, "label": "Mobile App Developer"},
  ];

  final List<Map<String, dynamic>> batchList = [
    {"id": 1, "label": "Batch 2"},
    {"id": 2, "label": "Batch 3"},
    {"id": 3, "label": "Batch 4"},
    {"id": 4, "label": "Batch 5"},
  ];

  Future<void> doRegister() async {
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passC.text.isEmpty ||
        gender == null ||
        selectedTraining == null ||
        selectedBatch == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi semua field")));
      return;
    }

    setState(() => loading = true);

    final success = await AuthApi.register(
      name: nameC.text,
      email: emailC.text,
      password: passC.text,
      gender: gender!,
      trainingId: selectedTraining!,
      batchId: selectedBatch!,
    );

    print("REGISTER RESULT: $success");

    setState(() => loading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register berhasil!")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal register")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),

            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            // Password + Visibility
            TextField(
              controller: passC,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: "Password",
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

            const SizedBox(height: 20),

            // Jenis Kelamin
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Jenis Kelamin"),
              items: const [
                DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                DropdownMenuItem(value: "P", child: Text("Perempuan")),
              ],
              onChanged: (v) => setState(() => gender = v),
            ),

            const SizedBox(height: 20),

            // Training Dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Training"),
              initialValue: selectedTraining,
              items: trainingList.map((e) {
                return DropdownMenuItem<int>(
                  value: e["id"],
                  child: Text(e["label"]),
                );
              }).toList(),
              onChanged: (v) {
                setState(() => selectedTraining = v);
              },
            ),

            const SizedBox(height: 20),

            // Batch Dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Batch"),
              initialValue: selectedBatch,
              items: batchList.map((e) {
                return DropdownMenuItem<int>(
                  value: e["id"],
                  child: Text(e["label"]),
                );
              }).toList(),
              onChanged: (v) {
                setState(() => selectedBatch = v);
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : doRegister,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
