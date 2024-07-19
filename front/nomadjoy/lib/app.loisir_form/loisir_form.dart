import 'package:flutter/material.dart';

// Définition des catégories possibles
const List<String> _categories = [
  'Livre',
  'Bande dessinée',
  'Manga',
  'Série',
  'Film',
];

// Définir la classe Loisir si elle n'existe pas déjà
class Loisir {
  final String oeuvre;
  String name;
  double note;
  String image;
  LoisirStatus status;
  String category; // Ajout de la catégorie

  Loisir({
    required this.oeuvre,
    required this.name,
    required this.note,
    required this.image,
    required this.status,
    this.category = '', // Valeur par défaut pour la catégorie
  });
}

enum LoisirStatus { ongoing, completed } // Définition de LoisirStatus

class LoisirForm extends StatefulWidget {
  final String oeuvreName;

  const LoisirForm({super.key, required this.oeuvreName});

  @override
  State<LoisirForm> createState() => _LoisirFormState();
}

class _LoisirFormState extends State<LoisirForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Loisir newLoisir;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    newLoisir = Loisir(
      oeuvre: widget.oeuvreName,
      name: '',
      note: 0,
      image: '',
      status: LoisirStatus.ongoing,
      category: _categories[0], // Initialiser la catégorie sélectionnée
    );
    _selectedCategory = _categories[0]; // Valeur par défaut
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Ajoutez ici la logique de traitement du formulaire, par exemple en envoyant `newLoisir` à une API ou en sauvegardant localement.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Nom',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le nom';
                }
                return null;
              },
              onSaved: (value) => newLoisir.name = value!,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Note',
              ),
              onSaved: (value) => newLoisir.note = double.parse(value!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez la note';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: 'Url image',
              ),
              onSaved: (value) => newLoisir.image = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez l\'Url';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // DropdownButton pour la sélection de catégorie
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                hintText: 'Choisissez la catégorie',
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  newLoisir.category = newValue ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Choisissez une catégorie';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  onPressed: submitForm,
                  child: const Text('Sauvegarder'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
