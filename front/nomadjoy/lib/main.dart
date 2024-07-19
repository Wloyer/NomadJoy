import 'package:flutter/material.dart';
import 'common_widget/general_card.dart';
import 'common_widget/constants.dart';
import 'package:nomadjoy/app.sign_in/sign_in_page.dart'; // Importation de la page de connexion
import 'common_widget/search_bar.dart' as NBSearchBar; // ajout
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
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const SignInPage(),
        '/loisir-form': (context) =>  LoisirFormView(), // ajout
        // Ajoutez d'autres routes si nécessaire
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
        title: Image.asset('images/nomadjoy_logo.png', height: 30),
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
            // Ajout de la search bar
             NBSearchBar.SearchBar(),
            GeneralCard(
              id: 1,
              imagePath: 'images/film_palmiers.jpg',
              title: 'Titre 1',
              subtitle: 'Sous-titre 1',
              ratings: [4, 5],
            ),
            GeneralCard(
              id: 2,
              imagePath: 'images/film_femme_chapeau.jpg',
              title: 'Titre 2',
              subtitle: 'Sous-titre 2',
              ratings: [3, 4],
            ),
            GeneralCard(
              id: 3,
              imagePath: 'images/film_femme_collier_plage.jpg',
              title: 'Titre 3',
              subtitle: 'Sous-titre 3',
              ratings: [5, 5],
            ),
            GeneralCard(
              id: 4,
              imagePath: 'images/film_smoke.jpg',
              title: 'Titre 4',
              subtitle: 'Sous-titre 4',
              ratings: [2, 3],
            ),
            GeneralCard(
              id: 5,
              imagePath: 'images/film_winter.jpg',
              title: 'Titre 5',
              subtitle: 'Sous-titre 5',
              ratings: [1, 2],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/loisir-form');
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
