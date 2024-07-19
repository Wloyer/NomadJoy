import 'package:flutter/material.dart';
import 'package:nomadjoy/app.loisir_form/loisir_form.dart';

class LoisirFormView extends StatelessWidget {
  static const String routeName = '/loisir-form';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Ajouter un loisir'),
      ),
      body: LoisirForm(),
    );
  }


}