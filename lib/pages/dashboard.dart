import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/listings.dart';
import 'package:mobile/models/orders.dart';
import 'package:mobile/pages/listing_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<dynamic> futurePrefs;
  late Future<Listings?> futureListings;
  late Future<Orders?> futureOrders;

  @override
  void initState() {
    super.initState();

    futurePrefs = fetchPrefs();
    futureListings = fetchListings();
    futureOrders = fetchOrders();

    // futureListings.then((value) => print(value?.embedded.listings.length));
    futureOrders.then((value) => print(value?.embedded.orders.length));
  }

  Future<Listings?> fetchListings() async {
    if ((await futurePrefs).getString('role') == 'buyer') return null;

    var sellerID = (await futurePrefs).getString('id');

    final response = await http.get(
        Uri.parse('http://192.168.1.6:8081/api/sellers/$sellerID/listings'));

    if (response.statusCode == 200) {
      return Listings.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load listings');
    }
  }

  Future<Orders?> fetchOrders() async {
    if ((await futurePrefs).getString('role') == 'seller') return null;

    var buyerID = (await futurePrefs).getString('id');

    final response = await http
        .get(Uri.parse('http://192.168.1.6:8081/api/buyers/${buyerID}/orders'));

    if (response.statusCode == 200) {
      return Orders.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<dynamic> fetchPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<bool> deleteListing(String id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.1.6:8081/api/listings/${id}'));

    print(response.statusCode);
    return response.statusCode == 204;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder<dynamic>(
          // future: futurePrefs,
          future: Future.wait([futurePrefs, futureListings, futureOrders]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else {
              var [prefs, listings, orders] = snapshot.data!;

              return prefs.getString('role') == 'buyer'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ORDERS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders.embedded.orders.length,
                          itemBuilder: (content, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // orders.embedded.orders[index].date.toString(),
                                  DateFormat('yyyy-MM-dd').format(orders
                                      .embedded.orders[index].date
                                      .toLocal()),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  orders.embedded.orders[index].total
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LISTINGS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listings.embedded.listings.length,
                          itemBuilder: (content, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listings.embedded.listings[index].name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton.icon(
                                  label: const Text(
                                    'Edit',
                                  ),
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListingForm(
                                          id: listings.embedded.listings[index]
                                              .links.self.href
                                              .split('/')
                                              .last,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                TextButton.icon(
                                  label: const Text(
                                    'Delete',
                                  ),
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    var id = listings.embedded.listings[index]
                                        .links.self.href
                                        .split('/')
                                        .last;

                                    await deleteListing(id);
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              label: const Text(
                                'Create listing',
                              ),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ListingForm(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }
}
