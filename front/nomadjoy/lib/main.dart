import 'package:flutter/material.dart';
import 'common_widget/general_card.dart';
import 'common_widget/constants.dart';
import 'package:nomadjoy/app.sign_in/sign_in_page.dart'; // Importez la page de connexion

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Changez cette ligne en '/' pour revenir à la page d'accueil
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const SignInPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.people_outline),
        title: Image.asset('images/nomadjoy_logo.png', height: 30,),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
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
    );
  }
}