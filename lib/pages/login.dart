import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/my_text_field.dart';
import 'package:mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleButtonPress(BuildContext context) async {
    print('${emailController.text} - ${passwordController.text}');

    // both must be placed before any async operation to avoid warning
    //`Don't use 'BuildContext's across async gaps.`
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final response = await http.get(Uri.parse(
        'http://192.168.1.6:8081/api/users/search/findByEmailAndPassword?email=${emailController.text}&password=${passwordController.text}'));

    if (response.statusCode == 200) {
      var user =
          User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

      print(user.toJson());

      var role = RegExp(r'.*/(buyer|seller)s/.*')
          .firstMatch(user.links.self.href)!
          .group(1)!;

      var id = user.links.self.href.split('/').last;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', emailController.text);
      await prefs.setString('role', role);
      await prefs.setString('id', id);

      navigator.pushNamed('/');

      // could use instead of `Navigator.of(context).pushNamed('/')`
      // but it triggers warning `Don't use 'BuildContext's across async gaps.`
      // Navigator.pushNamed(context, '/');
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Incorrect credentials. Please try again.'),
        ),
      );

      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.login,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: const Text('Forgot password?'),
                        onTap: () =>
                            {Navigator.pushNamed(context, '/reset-password')},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => handleButtonPress(context),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
