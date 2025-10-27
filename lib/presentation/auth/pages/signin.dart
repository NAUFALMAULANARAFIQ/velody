import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_mobile/common/widgets/appbar/app_bar.dart';
import 'package:project_mobile/common/widgets/button/basic_app_button.dart';
import 'package:project_mobile/core/configs/assets/app_vector.dart';
import 'package:project_mobile/presentation/auth/pages/signup.dart';
import 'package:project_mobile/presentation/home/pages/home.dart';

class SigninPages extends StatelessWidget {
  const SigninPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signupText(context),
      appBar: BasicAppbar(
        title: SvgPicture.asset(AppVector.logo, height: 40, width: 40),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            SizedBox(height: 50),
            _emailField(context),
            SizedBox(height: 20),
            _passwordField(context),
            SizedBox(height: 20),
            BasicAppButton(onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(),
              ),
            );
            }, title: 'Sign In'),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return Text(
      'Sign In',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }
}

Widget _emailField(BuildContext context) {
  return TextField(
    decoration: const InputDecoration(
      hintText: 'Enter Username Or Email',
    ).applyDefaults(Theme.of(context).inputDecorationTheme),
  );
}

Widget _passwordField(BuildContext context) {
  return TextField(
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
        Text(
          'Not A Remember? ',
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
          child: Text('Register Now'),
        ),
      ],
    ),
  );
}
