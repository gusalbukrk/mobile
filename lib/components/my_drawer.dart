import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  Future<void> deleteUserAndRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.remove('role');
  }

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
            leading: const Icon(Icons.list),
            title: const Text('Listings'),
            onTap: () {
              // otherwise, drawer will be open after back button is pressed
              Navigator.pop(context);

              Navigator.pushNamed(context, '/listings');
            },
          ),
          Expanded(child: Container()),
          FutureBuilder<String?>(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else {
                return snapshot.data == null
                    ? Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Sign Up'),
                            onTap: () {
                              // otherwise, drawer will be open after back button is pressed
                              Navigator.pop(context);

                              Navigator.pushNamed(context, '/signup');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.login),
                            title: const Text('Log In'),
                            onTap: () {
                              // otherwise, drawer will be open after back button is pressed
                              Navigator.pop(context);

                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.dashboard),
                            title: const Text('Dashboard'),
                            onTap: () {
                              // otherwise, drawer will be open after back button is pressed
                              Navigator.pop(context);

                              Navigator.pushNamed(context, '/dashboard');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Log Out'),
                            onTap: () {
                              // otherwise, drawer will be open after back button is pressed
                              Navigator.pop(context);

                              deleteUserAndRole();

                              Navigator.pushNamed(context, '/');
                            },
                          ),
                        ],
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
