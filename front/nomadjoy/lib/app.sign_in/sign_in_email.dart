import 'dart:convert'; // Pour utiliser jsonEncode et jsonDecode
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/api/api.dart'; // Importez le fichier API
import 'package:nomadjoy/common_widget/constants.dart';

import 'package:nomadjoy/app.sign_in/register_page.dart'; // Importez la page d'enregistrement

class SignInEmail extends StatefulWidget {
  const SignInEmail({super.key});

  @override
  State<SignInEmail> createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        final data = await ApiService.signIn(email, password);
        // La connexion a réussi
        print('Token: ${data['token']}');
        // Navigator.push(...);
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime la flèche de retour arrière
        title: Text(
          'Se connecter',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset('images/nomadjoy_logo.png', height: 100),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Email",
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez rentrer votre email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Mot de passe",
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez rentrer votre mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(color: errorRed),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor, // Utilisez colorBlue défini dans constants.dart
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Se connecter',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: Text(
                  'Créer un compte',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: blueColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
