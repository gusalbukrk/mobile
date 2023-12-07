import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuyerDashboard extends StatelessWidget {
  BuyerDashboard({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> handleButtonPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.1.6:8081/api/listings'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': titleController.text,
          'price': priceController.text,
          'quantity': quantityController.text,
          'description': descriptionController.text,
        }),
      );

      if (response.statusCode == 201) {
        titleController.clear();
        priceController.clear();
        quantityController.clear();
        descriptionController.clear();
      }
    }
  }

  String? requiredValidation(String name, String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create listing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (value) => requiredValidation('title', value),
            ),
            TextFormField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
              validator: (value) => requiredValidation('price', value),
            ),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value) => requiredValidation('quantity', value),
            ),
            SizedBox(
              height: 200,
              child: TextFormField(
                controller: descriptionController,
                minLines: null,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => handleButtonPressed(context),
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
