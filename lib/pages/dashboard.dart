import 'package:flutter/material.dart';
import 'package:mobile/pages/listing_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  Future<dynamic> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
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
          future: getPrefs(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else {
              return snapshot.data.getString('role') == 'buyer'
                  ? Container()
                  : Column(
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
                        TextButton.icon(
                          label: const Text(
                            'Update listing',
                          ),
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListingForm(
                                  id: '1',
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
            }
          },
        ),
      ),
    );
  }
}
