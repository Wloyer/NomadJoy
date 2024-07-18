import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final int rating;

  GeneralCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.firaSans(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ) ),
              
            ),
            Text(
              subtitle,

              style: GoogleFonts.numans(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ) ),

            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Note: $rating/5',

                  style: GoogleFonts.numans(
                  textStyle: TextStyle(
                  fontSize: 16,
                ) ),

                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Logique pour ajouter un nouvel élément
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
