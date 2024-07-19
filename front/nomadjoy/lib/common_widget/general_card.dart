import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/api/api.dart';

class GeneralCard extends StatefulWidget {
  final int id;
  final String imagePath;
  final String title;
  final String subtitle;
  final List<int> ratings;

  GeneralCard({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.ratings,
  });

  @override
  _GeneralCardState createState() => _GeneralCardState();
}

class _GeneralCardState extends State<GeneralCard> {
  int _userRating = 0;

  double get _averageRating {
    if (widget.ratings.isEmpty) {
      return 0.0;
    }
    return widget.ratings.reduce((a, b) => a + b) / widget.ratings.length;
  }

  Future<void> _rateActivity(int rating) async {
    try {
      await ApiService.rateActivity(widget.id, 1, rating); // Remplacez `1` par l'ID de l'utilisateur réel
      setState(() {
        widget.ratings.add(rating);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to rate activity: $error',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
              widget.imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: GoogleFonts.firaSans(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              widget.subtitle,
              style: GoogleFonts.numans(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Note: ${_averageRating.toStringAsFixed(1)}/5',
                  style: GoogleFonts.numans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showRatingDialog();
                  },
                ),
              ],
            ),
            _buildRatingStars(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _userRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _userRating = index + 1;
            });
            _rateActivity(_userRating);
          },
        );
      }),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Noter l\'activité', style: GoogleFonts.lato()),
          content: _buildRatingStars(),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler', style: GoogleFonts.lato()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Soumettre', style: GoogleFonts.lato()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
