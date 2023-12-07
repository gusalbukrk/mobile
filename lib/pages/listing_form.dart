import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/listing.dart';
import 'package:http_parser/http_parser.dart';

class ListingForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final List<File> _images = [];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<String> createListing() async {
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

    var createdListingURI =
        Listing.fromJson(jsonDecode(response.body)).links.self.href;

    return createdListingURI;
  }

  Future<List<String>> uploadImage() async {
    var uri = Uri.parse('http://192.168.1.6:8081/api/images');

    List<String> ids = [];

    for (var image in _images) {
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();
      var idString = (await http.Response.fromStream(response)).body;
      ids.add(idString);
    }

    return ids;
  }

  Future<void> associateImageWithLListing(
      String listing, List<String> images) async {
    await http.post(
      Uri.parse('$listing/images'),
      headers: <String, String>{
        'Content-Type': 'text/uri-list',
      },
      body: images.join('\n'),
    );
  }

  Future<void> handleButtonPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var listingURI = await createListing();
      var imagesIDs = await uploadImage();
      await associateImageWithLListing(listingURI, imagesIDs);

      // if (response.statusCode == 201) {
      titleController.clear();
      priceController.clear();
      quantityController.clear();
      descriptionController.clear();
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing created!'),
        ),
      );
    }
  }

  String? requiredValidation(String name, String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a $name';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> images = await _picker.pickMultiImage();

    for (var image in images) {
      _images.add(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Listing'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    label: const Text('Pick Image'),
                    icon: const Icon(Icons.add_a_photo),
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
          ),
        ));
  }
}
