import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/register_model.dart';
import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final batchC = TextEditingController();
  final trainingC = TextEditingController();
  final passC = TextEditingController();

  bool loading = false;

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
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),
              TextFormField(
                controller: batchC,
                decoration: const InputDecoration(labelText: "Batch"),
                validator: (v) => v!.isEmpty ? "Batch wajib diisi" : null,
              ),
              TextFormField(
                controller: trainingC,
                decoration: const InputDecoration(labelText: "Training ID"),
                validator: (v) => v!.isEmpty ? "Training ID wajib diisi" : null,
              ),
              TextFormField(
                controller: passC,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                    v!.length < 6 ? "Password minimal 6 karakter" : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);

                          final data = RegisterModel(
                            name: nameC.text.trim(),
                            email: emailC.text.trim(),
                            password: passC.text.trim(),
                            jenisKelamin: "L",
                            profilePhoto: "",
                            batchId: int.parse(batchC.text.trim()),
                            trainingId: int.parse(trainingC.text.trim()),
                          );

                          try {
                            bool success = await auth.register(data);

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Register Berhasil"),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }

                          setState(() => loading = false);
                        }
                      },
                child: Text(loading ? "Loading..." : "Daftar Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
