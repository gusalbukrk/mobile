import 'package:flutter/material.dart';
import 'package:mobile/components/my_drawer.dart';
import 'package:mobile/providers/counter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String?> user;

  @override
  void initState() {
    super.initState();

    user = getUser();
  }

  Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: user,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return CircularProgressIndicator();
                  return const Text('loading....');
                } else {
                  // Use snapshot.data here
                  return Text('Hello, ${snapshot.data ?? "visitor"}!');
                }
              },
            ),
            const Text(
              'You have pushed the button this many times:',
            ),

            // Consumer and context.watch are equivalent
            // use Consumer when context isn't available
            // https://stackoverflow.com/a/72058451
            //
            // Consumer<CounterProvider>(
            //   builder: (context, value, child) {
            //     return Text(
            //       '${value.countVal.toString()}',
            //       style: Theme.of(context).textTheme.headlineMedium,
            //     );
            //   },
            // ),
            //
            Text(
              // wouldn't work
              // `context.read` is used when you want to access the data from the provider
              // but don't need the widget to rebuild when the provider updates
              // it's typically used in event handlers (like onPressed)
              // context.read<CounterProvider>().countVal.toString(),
              //
              // used to listen to changes in the provider
              // when changes are detected, the widget that calls `watch` will be rebuild
              context.watch<CounterProvider>().countVal.toString(),

              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<CounterProvider>().add,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
