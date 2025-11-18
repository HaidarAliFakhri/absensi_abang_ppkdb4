import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/register_request.dart';
import '../state_provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final batchC = TextEditingController();
  final trainingC = TextEditingController();
  final photoC = TextEditingController();

  String gender = "L";
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// --- NAME
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),

              /// --- EMAIL
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),

              /// --- PASSWORD
              TextFormField(
                controller: passC,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                validator: (v) =>
                    v!.length < 6 ? "Password minimal 6 karakter" : null,
              ),

              const SizedBox(height: 20),

              /// --- JENIS KELAMIN
              DropdownButtonFormField<String>(
                initialValue: gender,
                items: const [
                  DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                  DropdownMenuItem(value: "P", child: Text("Perempuan")),
                ],
                decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                onChanged: (v) => setState(() => gender = v!),
              ),

              /// --- PROFILE PHOTO (Optional)
              TextFormField(
                controller: photoC,
                decoration: const InputDecoration(
                  labelText: "Profile Photo (base64 optional)",
                ),
              ),

              /// --- BATCH ID
              TextFormField(
                controller: batchC,
                decoration: const InputDecoration(labelText: "Batch ID"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Batch wajib diisi" : null,
              ),

              /// --- TRAINING ID
              TextFormField(
                controller: trainingC,
                decoration: const InputDecoration(labelText: "Training ID"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Training ID wajib diisi" : null,
              ),

              const SizedBox(height: 30),

              /// --- BUTTON SUBMIT
              ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final req = RegisterRequest(
                            name: nameC.text.trim(),
                            email: emailC.text.trim(),
                            password: passC.text.trim(),
                            jenisKelamin: gender,
                            profilePhoto: photoC.text.trim(),
                            batchId: int.parse(batchC.text.trim()),
                            trainingId: int.parse(trainingC.text.trim()),
                          );

                          final success = await auth.register(req);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registrasi Berhasil"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registrasi gagal, cek kembali data",
                                ),
                              ),
                            );
                          }
                        }
                      },
                child: Text(auth.isLoading ? "Loading..." : "Daftar Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
