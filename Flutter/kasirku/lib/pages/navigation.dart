import 'package:flutter/material.dart';
import 'package:sop_app/pages/menus.dart';
import 'package:sop_app/pages/shopping.dart';

class Navigation extends StatefulWidget {
  static const routeName = '/navigation';

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPage = 0;

  List<Widget> _pages = [Shopping(), Menus()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
      selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'belanja'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
        ],
        currentIndex: _currentPage,
        onTap: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
    );
  }
}
