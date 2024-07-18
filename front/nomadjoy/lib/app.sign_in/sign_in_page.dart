import 'package:flutter/material.dart';
import 'package:nomadjoy/app.sign_in/sign_in_button.dart';
import 'package:nomadjoy/app.sign_in/sign_in_email.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 8.0),
            SignInButton(
              text: 'Se connecter',
              textColor: Colors.white,
              color: const Color(0xFFB9848C),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInEmail()),
                );
              },
            ),
            const SizedBox(height: 8.0),
            const Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            SignInButton(
              text: 'Login',
              textColor: Colors.black87,
              color: Color(0x2F70AFFF),
              onPressed: () {
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
