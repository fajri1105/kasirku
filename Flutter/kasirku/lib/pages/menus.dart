import 'package:flutter/material.dart';
import 'package:sop_app/pages/account.dart';
import 'package:sop_app/pages/new_product.dart';
import 'package:sop_app/pages/order_history.dart';

class Menus extends StatelessWidget {
  static const routeName = '/menus';

  List<Map<String, dynamic>> _myMenus = [
    {
      'title': 'Riwayat Pemesanan',
      'icon': Icons.history,
      'page': OrderHistory.routeName
    },
    {
      'title': 'Produk Baru',
      'icon': Icons.add_box,
      'page': NewProduct.routeName
    },
    {'title': 'Laporan', 'icon': Icons.note, 'page': Account.routeName},
    {'title': 'Akun', 'icon': Icons.account_box, 'page': Account.routeName},
  ];

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          '',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: _myMenus.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, _myMenus[i]['page']);
                    },
                    leading: Icon(_myMenus[i]['icon']),
                    title: Text(_myMenus[i]['title']),
                  ),
                );
              })),
    );
  }
}
