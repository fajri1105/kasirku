import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sop_app/my_env.dart';
import 'package:sop_app/pages/login.dart';
import 'package:sop_app/pages/navigation.dart';

class LoginCheck extends StatelessWidget {
  static const routeName = '/login-check';

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    return Scaffold(
      body: FutureBuilder(
        future: storage.read(key: 'api_token'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (snapshot.data == null) {
                Navigator.pushReplacementNamed(context, Login.routeName);
              } else {
                MyEnv.token = snapshot.data;
                Navigator.pushReplacementNamed(context, Navigation.routeName);
              }
            });
            // Return a placeholder widget while waiting for navigation
            return const Center(
              child: Text('Redirecting...'),
            );
          } else {
            // Handle other connection states, if necessary
            return const Center(
              child: Text('Error loading data'),
            );
          }
        },
      ),
    );
  }
}
