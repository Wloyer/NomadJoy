import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Top5Page extends StatelessWidget {
  const Top5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 5'),
      ),
      body: ListView.builder(
        itemCount: 5, // Top 5 items
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                'Nom du loisir $index',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                'Type de loisir $index',
                style: GoogleFonts.lato(),
              ),
              trailing: Text(
                'Note: ${(index + 1) * 1}/5',
                style: GoogleFonts.lato(),
              ),
            ),
          );
        },
      ),
    );
  }
}
