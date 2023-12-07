import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/my_text_field.dart';
import 'package:mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum UserType { buyer, seller }

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final docController = TextEditingController();
  final userTypeController = ValueNotifier<UserType>(UserType.buyer);

  Future<void> handleButtonPress(BuildContext context) async {
    print('${emailController.text} - ${passwordController.text}');

    // both must be placed before any async operation to avoid warning
    //`Don't use 'BuildContext's across async gaps.`
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final response = await http.post(
      Uri.parse(
          'http://192.168.1.6:8081/api/${userTypeController.value == UserType.buyer ? 'buyers' : 'sellers'}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
        'password': passwordController.text,
        if (userTypeController.value == UserType.buyer)
          'cpf': docController.text,
        if (userTypeController.value == UserType.seller)
          'cnpj': docController.text,
      }),
    );

    if (response.statusCode == 201) {
      navigator.pushNamed('/login');

      // could use instead of `Navigator.of(context).pushNamed('/')`
      // but it triggers warning `Don't use 'BuildContext's across async gaps.`
      // Navigator.pushNamed(context, '/');
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please try again.'),
        ),
      );

      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
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
                    'Welcome!',
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
                  MyTextField(
                    controller: docController,
                    hintText: 'CPF/CNPJ',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ValueListenableBuilder(
                    valueListenable: userTypeController,
                    builder: (context, UserType value, _) {
                      return DropdownButton<UserType>(
                        value: value,
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (UserType? newValue) {
                          userTypeController.value = newValue!;
                        },
                        items: const <DropdownMenuItem<UserType>>[
                          DropdownMenuItem<UserType>(
                            value: UserType.buyer,
                            child: Text('Buyer'),
                          ),
                          DropdownMenuItem<UserType>(
                            value: UserType.seller,
                            child: Text('Seller'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => handleButtonPress(context),
                      child: const Text(
                        'Sign Up',
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
