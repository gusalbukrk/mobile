import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/listing.dart';

class ListingPage extends StatefulWidget {
  final String id;

  const ListingPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late Future<Listing> futureListing;

  @override
  void initState() {
    super.initState();

    futureListing = fetchListing();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<Listing>(
        future: futureListing,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data!.name,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  '\$${snapshot.data!.price.toString()}',
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
    );
  }
}
