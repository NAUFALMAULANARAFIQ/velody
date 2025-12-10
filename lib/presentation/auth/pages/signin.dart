import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile/common/widgets/appbar/app_bar.dart';
import 'package:project_mobile/common/widgets/button/basic_app_button.dart';
import 'package:project_mobile/core/configs/assets/app_vector.dart';
import 'package:project_mobile/presentation/auth/pages/signup.dart';
import 'package:project_mobile/presentation/home/pages/home.dart';
import 'package:project_mobile/services/auth_service.dart'; // Import AuthService

class SigninPages extends StatefulWidget {
  const SigninPages({super.key});

  @override
  State<SigninPages> createState() => _SigninPagesState();
}

class _SigninPagesState extends State<SigninPages> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    // Validasi
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi")),
      );
      return;
    }

    setState(() => loading = true);

    // Panggil AuthService Firebase
    String? error = await AuthService().signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      // Sukses Login -> Pindah ke Home
      // (main.dart akan otomatis mendeteksi login, tapi kita push manual biar UX enak)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      // Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signupText(context),
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
              _emailField(context),
              const SizedBox(height: 20),
              _passwordField(context),
              const SizedBox(height: 20),
              BasicAppButton(
                onPressed: loading ? null : login,
                title: loading ? "Signing In..." : 'Sign In',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Sign In',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        // Firebase Login WAJIB pakai Email, bukan Username
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

  Widget _signupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Not A Member? ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SignupPages(),
                ),
              );
            },
            child: const Text('Register Now'),
          ),
        ],
      ),
    );
  }
}