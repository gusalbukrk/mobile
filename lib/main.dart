import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CounterProvider())],
      child: MaterialApp(
        title: 'Marketplace',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const MyHomePage(title: 'Homepage'),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

class CounterProvider extends ChangeNotifier {
  int _countVal = 0;

  int get countVal => _countVal;

  void add() {
    _countVal++;
    notifyListeners();
  }
}
