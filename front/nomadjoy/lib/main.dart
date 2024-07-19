import 'package:flutter/material.dart';
import 'common_widget/general_card.dart';
import 'common_widget/constants.dart';
import 'package:nomadjoy/app.sign_in/sign_in_page.dart'; // Importation de la page de connexion
import 'common_widget/search_bar.dart'; // ajout
import 'app.loisir_form/loisir_form_view.dart'; // ajout



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
            //c'est ici qu'il faudrait ajouter la search bar
            GeneralCard(
              imagePath: 'images/film_palmiers.jpg',
              title: 'Titre 1',
              subtitle: 'Sous-titre 1',
              rating: 4,
            ),
            GeneralCard(
              imagePath: 'images/film_femme_chapeau.jpg',
              title: 'Titre 2',
              subtitle: 'Sous-titre 2',
              rating: 3,
            ),
            GeneralCard(
              imagePath: 'images/film_femme_collier_plage.jpg',
              title: 'Titre 3',
              subtitle: 'Sous-titre 3',
              rating: 5,
            ),
            GeneralCard(
              imagePath: 'images/film_smoke.jpg',
              title: 'Titre 4',
              subtitle: 'Sous-titre 4',
              rating: 2,
            ),
            GeneralCard(
              imagePath: 'images/film_winter.jpg',
              title: 'Titre 5',
              subtitle: 'Sous-titre 5',
              rating: 1,
            ),
          ],
        ),
      ),


      bottomNavigationBar: BottomAppBar( // changement de la nav bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/loisir-form'); //ajout
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/note-form');
              },
            ),
          ],
        ),
      ),
    );
  }
}