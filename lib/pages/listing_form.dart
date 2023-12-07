import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/images.dart';
import 'package:mobile/models/listing.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingForm extends StatefulWidget {
  final String? id;

  const ListingForm({Key? key, this.id}) : super(key: key);

  @override
  State<ListingForm> createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingForm> {
  final _formKey = GlobalKey<FormState>();

  final List<File> _images = [];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();

  late Future<Listing?> futureListing;
  late Future<Images?> futureImages;

  @override
  void initState() {
    super.initState();

    futureListing = fetchListing();
    futureImages = fetchImages();

    futureListing.then((value) => print(value?.name));
  }

  Future<Listing?> fetchListing() async {
    if (widget.id == null) return null;

    final response = await http
        .get(Uri.parse('http://192.168.1.6:8081/api/listings/${widget.id}'));

    if (response.statusCode == 200) {
      return Listing.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listing');
    }
  }

  Future<Images?> fetchImages() async {
    if (widget.id == null) return null;

    final response = await http.get(
        Uri.parse('http://192.168.1.6:8081/api/listings/${widget.id}/images'));

    if (response.statusCode == 200) {
      return Images.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listing images');
    }
  }

  Future<String> createListing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellerID = prefs.getString('id');

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
        'seller': 'http://192.168.1.6:8081/api/sellers/$sellerID',
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

  Future<bool> updateListing() async {
    var uri = Uri.parse((await futureListing)!.links.self.href);

    final response = await http.put(
      uri,
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

    return response.statusCode == 204;
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (widget.id == null) {
      // create listing
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
    } else {
      // update listing
      await updateListing();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing updated!'),
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
          // title: const Text('Listing'),
          title: Text(widget.id == null ? 'Listing' : 'Listing #${widget.id}'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: FutureBuilder<dynamic>(
              future: Future.wait([futureListing, futureImages]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var [listing, images] = snapshot.data;

                  titleController.text = listing?.name ?? '';
                  priceController.text = listing?.price.toString() ?? '';
                  quantityController.text = listing?.quantity.toString() ?? '';
                  descriptionController.text = listing?.description ?? '';

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          validator: (value) =>
                              requiredValidation('title', value),
                        ),
                        TextFormField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Price',
                          ),
                          validator: (value) =>
                              requiredValidation('price', value),
                        ),
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                          ),
                          validator: (value) =>
                              requiredValidation('quantity', value),
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
                        if (widget.id == null)
                          Column(
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                label: const Text('Pick Image'),
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => handleSubmit(context),
                            child: Text(
                              widget.id == null ? 'Create' : 'Update',
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
