import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/api/api.dart'; // Importez le fichier API
import 'package:nomadjoy/common_widget/constants.dart';
import 'package:nomadjoy/common_widget/general_card.dart'; // Importez la page card.dart

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      try {
        final data = await ApiService.register(name, email, password);
        if (data.containsKey('error')) {
          setState(() {
            _errorMessage = data['error'];
          });
        } else {
          // L'inscription et la connexion ont réussi
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  GeneralCard(imagePath: '', title: '', subtitle: '', rating:2 ,)), // Redirigez vers la page card.dart
          );
        }
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
        automaticallyImplyLeading: true, // Affiche la flèche de retour arrière
        title: Text(
          'Créer un compte',
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
                controller: _nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Nom",
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
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
                    return 'Veuillez entrer votre email';
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
                    return 'Veuillez entrer votre mot de passe';
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
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor, // Utilisez colorBlue défini dans constants.dart
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Créer un compte',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
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
