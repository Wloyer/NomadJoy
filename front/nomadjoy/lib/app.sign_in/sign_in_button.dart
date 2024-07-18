import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final double borderRadius;

  const SignInButton({super.key, 
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.borderRadius = 2.0, // Valeur par défaut si non spécifiée
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ),
    );
  }
}
