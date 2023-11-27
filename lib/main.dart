import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/listings.dart';
import 'package:mobile/pages/reset_password.dart';
import 'package:mobile/providers/counter.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/listings',
        routes: {
          '/': (context) => const HomePage(title: 'Home'),
          '/login': (context) => LoginPage(),
          '/reset-password': (context) => const ResetPasswordPage(),
          '/listings': (context) => const ListingsPage(),
        },
      ),
    );
  }
}
