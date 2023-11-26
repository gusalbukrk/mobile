import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.shopping_bag,
              size: 50,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // otherwise, drawer will be open after back button is pressed
              Navigator.pop(context);

              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              // otherwise, drawer will be open after back button is pressed
              Navigator.pop(context);

              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
