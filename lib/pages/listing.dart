import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/images.dart';
import 'package:mobile/models/listing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingPage extends StatefulWidget {
  final String id;

  const ListingPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late Future<dynamic> futurePrefs;
  late Future<Listing> futureListing;
  late Future<Images> futureImages;

  @override
  void initState() {
    super.initState();

    futurePrefs = fetchPrefs();
    futureListing = fetchListing();
    futureImages = fetchImages();

    // how to execute something after fetching
    // futureListing.then((value) => print(value.name));
  }

  Future<dynamic> fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<Listing> fetchListing() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.6:8081/api/listings/${widget.id}'));

    if (response.statusCode == 200) {
      return Listing.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listing');
    }
  }

  Future<Images> fetchImages() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.6:8081/api/listings/${widget.id}/images'));

    if (response.statusCode == 200) {
      return Images.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listing images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder<dynamic>(
          future: Future.wait([futurePrefs, futureListing, futureImages]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var [prefs, listing, images] = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.embedded.images.length,
                      itemBuilder: (context, index) {
                        String name = images.embedded.images[index].name;

                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Image.network(
                            'http://192.168.1.6:8081/api/images/findByName/${name}',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    listing.name,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    '${listing.quantity.toString()} units left',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    '\$${listing.price.toString()}',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    listing.description ?? 'No description.',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (prefs.getString('role') == 'buyer')
                    ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Buy'),
                      onPressed: () async {
                        final response = await http.post(
                          Uri.parse('http://192.168.1.6:8081/api/orders'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'buyer':
                                'http://localhost:8081/api/buyers/${prefs.getString('id')!}',
                            'total': listing.price.toString(),
                            'date': DateFormat('yyyy-MM-dd')
                                .format(DateTime.now().toLocal()),
                          }),
                        );

                        if (response.statusCode == 201) {
                          final resp = await http.put(
                            Uri.parse(
                                'http://192.168.1.6:8081/api/listings/${widget.id}'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'name': listing.name.toString(),
                              'price': listing.price.toString(),
                              'quantity':
                                  (int.parse(listing.quantity.toString()) - 1)
                                      .toString(),
                              'description': listing.description.toString(),
                            }),
                          );

                          print(resp.statusCode);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order received!'),
                            ),
                          );
                        }
                      },
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
