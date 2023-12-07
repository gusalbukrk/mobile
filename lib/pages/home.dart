import 'package:flutter/material.dart';
import 'package:mobile/components/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> user;
  late Future<String?> role;
  late Future<String?> id;

  @override
  void initState() {
    super.initState();

    user = getPref('user');
    role = getPref('role');
    id = getPref('id');
  }

  Future<String?> getPref(String pref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(pref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FutureBuilder<List<String?>>(
            // future: user,
            future: Future.wait([user, role, id]),
            builder:
                (BuildContext context, AsyncSnapshot<List<String?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading....');
              } else {
                var [user, role, id] = snapshot.data!;

                return Text(
                  user == null
                      ? 'Hello, visitor!'
                      // : 'Hello, $user (role: $role, id: $id)!',
                      : 'Welcome back, $user!',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
