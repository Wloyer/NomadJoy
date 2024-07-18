import 'package:flutter/material.dart';
import 'common_widget/general_card.dart';
import 'common_widget/constants.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person),
          title: Image.asset('images/nomadjoy_logo.png', height: 30,),
          
        ),

        body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Top 5 Livres',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GeneralCard(
              imagePath: 'images/film_palmiers.jpg',
              title: 'Titre 1',
              subtitle: 'Sous-titre 1',
              rating: 1,
            ),
          ],
        ),
      ),
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(label: 'Ajouter oeuvre', icon: Icon(Icons.add)),
        BottomNavigationBarItem(label: 'Noter', icon: Icon(Icons.add))
      ],
      backgroundColor: Colors.white,
      selectedItemColor: purpuleColor,
      unselectedItemColor: pinkColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 40,
    ),
  )));
}