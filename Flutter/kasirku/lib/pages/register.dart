import 'package:flutter/material.dart';
import 'package:sop_app/models/user.dart';
import 'package:sop_app/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:sop_app/provider/user_provider.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmationController =
      TextEditingController();
  List<Map<String, dynamic>> fields = [];
  String? _error = null;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fields = [
      {
        'title': 'Nama Toko',
        'controller': _nameController,
        'obsecure': false,
        'keyboardType': TextInputType.name,
        'icon': Icons.person,
      },
      {
        'title': 'Email',
        'controller': _emailController,
        'obsecure': false,
        'keyboardType': TextInputType.emailAddress,
        'icon': Icons.mail,
      },
      {
        'title': 'No. Hp',
        'controller': _phoneController,
        'obsecure': false,
        'keyboardType': TextInputType.phone,
        'icon': Icons.phone,
      },
      {
        'title': 'Alamat',
        'controller': _addressController,
        'obsecure': false,
        'keyboardType': TextInputType.text,
        'icon': Icons.location_city,
      },
      {
        'title': 'Password',
        'controller': _passwordController,
        'obsecure': true,
        'keyboardType': TextInputType.text,
        'icon': Icons.password,
      },
      {
        'title': 'Konfirmasi Password',
        'controller': _passwordConfirmationController,
        'obsecure': true,
        'keyboardType': TextInputType.text,
        'icon': Icons.password,
      },
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmationController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      setState(() {
        _error = 'Semua kolom harus diisi!';
        _isLoading = false;
      });
      return;
    }
    if (_passwordController.text != _passwordConfirmationController.text) {
      setState(() {
        _error = 'Konfirmasi password salah!';
        _isLoading = false;
      });
      return;
    }

    try {
      User user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      await context.read<UserProvider>().register(user);

      Navigator.pushReplacementNamed(context, Login.routeName);
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              Text(
                'Daftar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Text('Selamat Datang'),
              SizedBox(
                height: 60,
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
                      textInputAction: TextInputAction.next,
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
                        _register();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 25),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        "Daftar",
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
                  Text('Sudah punya akun? '),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Login.routeName);
                      },
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
