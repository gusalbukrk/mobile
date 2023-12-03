import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: const Text(
            'Dashboard',
          ),
        ),
      ),
    );
  }
}
