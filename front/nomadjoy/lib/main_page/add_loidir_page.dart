import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadjoy/api/api.dart';
import 'package:nomadjoy/common_widget/constants.dart';

class AddLoisirPage extends StatefulWidget {
  const AddLoisirPage({super.key});

  @override
  State<AddLoisirPage> createState() => _AddLoisirPageState();
}

class _AddLoisirPageState extends State<AddLoisirPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  String? _errorMessage;
  List<dynamic>? _categories;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _addLoisir() async {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final author = _authorController.text;
      final type = _typeController.text;
      final categoryId = int.tryParse(_selectedCategory ?? '0') ?? 0;

      if (categoryId == 0) {
        setState(() {
          _errorMessage = 'Veuillez sélectionner une catégorie';
        });
        return;
      }

      try {
        final data = {
          'category_id': categoryId,
          'user_id': 1, // Utilisez une fausse `user_id`
          'title': title,
          'description': description,
          'datePublication': DateTime.now().toIso8601String(),
          'author': author,
          'type': type,
        };

        await ApiService.addActivity(data);
        _showSuccessMessage();
        _clearForm();
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loisir ajouté avec succès !',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _authorController.clear();
    _typeController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un loisir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Nom du loisir',
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du loisir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Description',
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Auteur',
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'auteur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Type',
                  hintStyle: GoogleFonts.lato(),
                ),
                style: GoogleFonts.lato(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Sélectionnez une catégorie', style: GoogleFonts.lato()),
                items: _categories?.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['name'], style: GoogleFonts.lato()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: errorRed),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: _addLoisir,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Ajouter',
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
