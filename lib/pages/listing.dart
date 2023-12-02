import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/images.dart';
import 'package:mobile/models/listing.dart';

class ListingPage extends StatefulWidget {
  final String id;

  const ListingPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late Future<Listing> futureListing;
  late Future<Images> futureImages;

  @override
  void initState() {
    super.initState();

    futureListing = fetchListing();
    futureImages = fetchImages();

    // how to execute something after fetching
    // futureListing.then((value) => print(value.name));
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
      body: FutureBuilder<dynamic>(
        future: Future.wait([futureListing, futureImages]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var [listing, images] = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.embedded.images.length,
                    itemBuilder: (context, index) {
                      String name = images.embedded.images[index].name;

                      return Image.network(
                        'http://192.168.1.6:8081/api/images/findByName/${name}',
                      );
                    },
                  ),
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
                  '\$${listing.price.toString()}',
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  listing.description,
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
