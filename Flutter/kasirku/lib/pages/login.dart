import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sop_app/pages/navigation.dart';
import 'package:sop_app/pages/register.dart';
import 'package:sop_app/pages/shopping.dart';
import 'package:sop_app/provider/user_provider.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  List<Map<String, dynamic>> fields = [];
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fields = [
      {
        'title': 'Email',
        'controller': _emailController,
        'obsecure': false,
        'keyboardType': TextInputType.emailAddress,
        'icon': Icons.mail,
      },
      {
        'title': 'Password',
        'controller': _passwordController,
        'obsecure': true,
        'keyboardType': TextInputType.text,
        'icon': Icons.password,
      },
    ];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _error = 'Semua kolom harus diisi!';
        _isLoading = false;
      });
      return;
    }

    try {
      await context
          .read<UserProvider>()
          .login(_emailController.text, _passwordController.text);

      Navigator.pushReplacementNamed(context, Navigation.routeName);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masuk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                Text('Selamat Datang Kembali'),
                SizedBox(
                  height: 30,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ...fields.map((e) {
                  return Column(
                    children: [
                      TextField(
                        controller: e['controller'],
                        keyboardType: e['keyboardType'],
                        enableSuggestions: true,
                        autocorrect: false,
                        obscureText: e['obsecure'],
                        decoration: InputDecoration(
                          hintText: e['title'],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.red.withOpacity(0.1),
                          filled: true,
                          prefixIcon: Icon(e['icon']),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
                SizedBox(
                  height: 25,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? '),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Register.routeName);
                        },
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
