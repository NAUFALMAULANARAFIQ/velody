import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile/common/widgets/appbar/app_bar.dart';
import 'package:project_mobile/common/widgets/button/basic_app_button.dart';
import 'package:project_mobile/core/configs/assets/app_vector.dart';
import 'package:project_mobile/presentation/auth/pages/signin.dart';
import 'package:project_mobile/services/auth_service.dart'; // Import AuthService

class SignupPages extends StatefulWidget {
  const SignupPages({super.key});

  @override
  State<SignupPages> createState() => _SignupPagesState();
}

class _SignupPagesState extends State<SignupPages> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    // Validasi input kosong
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    setState(() => loading = true);

    // Panggil AuthService Firebase
    String? error = await AuthService().signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: fullnameController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      // Sukses (Errornya null)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
      );

      // Pindah ke halaman Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SigninPages()),
      );
    } else {
      // Gagal (Tampilkan pesan error dari Firebase)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error"), backgroundColor: Colors.red),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signinText(context),
      appBar: BasicAppbar(
        title: SvgPicture.asset(AppVector.logo, height: 40, width: 40),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _registerText(),
              const SizedBox(height: 50),
              _fullNameField(context),
              const SizedBox(height: 20),
              _emailField(context),
              const SizedBox(height: 20),
              _passwordField(context),
              const SizedBox(height: 20),
              BasicAppButton(
                onPressed: loading ? null : register,
                title: loading ? "Creating Account..." : "Create Account",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: fullnameController,
      decoration: const InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signinText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account? ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SigninPages(),
                ),
              );
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }
}