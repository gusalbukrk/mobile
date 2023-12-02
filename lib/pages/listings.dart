import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/listings.dart';
import 'package:mobile/pages/listing.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  _ListingsPageState createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late Future<Listings> futureListings;

  @override
  void initState() {
    super.initState();

    futureListings = fetchListings();
  }

  Future<Listings> fetchListings() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.6:8081/api/listings'));

    if (response.statusCode == 200) {
      return Listings.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<Listings>(
        future: futureListings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.embedded.listings.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Text(
                    snapshot.data!.embedded.listings[index].name,
                  ),
                  onTap: () {
                    String id = snapshot
                        .data!.embedded.listings[index].links.self.href
                        .split('/')
                        .last;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingPage(
                          id: id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
