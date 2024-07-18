import 'package:flutter/material.dart';
import 'package:nomadjoy/app.sign_in/sign_in_button.dart';
import 'package:nomadjoy/app.sign_in/sign_in_email.dart';
import 'package:nomadjoy/common_widget/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/app.sign_in/register_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour arrière
        title: const Text(
          'Bienvenue',
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
            // Logo "nomadjoy" au centre
            Center(
              child: Image.asset('images/nomadjoy_logo.png', height: 100),
            ),
            const SizedBox(height: 32.0),
            SignInButton(
              text: 'Connexion',
              textColor: Colors.white,
              color: purpuleColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInEmail()),
                );
              },
              borderRadius: 30.0, // Arrondir les bords du bouton
            ),
            const SizedBox(height: 8.0),
            const Text(
              'ou',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
            const SizedBox(height: 8.0),
            SignInButton(
              text: 'Créer un compte',
              textColor: Colors.white,
              color: blueColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              borderRadius: 30.0, 
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
