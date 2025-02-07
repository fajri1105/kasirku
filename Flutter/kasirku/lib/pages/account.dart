import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  static const routeName = '/account';

  List<List<String>> _myData = [
    ['Nama', 'FJR Shop'],
    ['Email', 'fjrproject11@gmail.com'],
    ['Alamat', 'Jl Jendral Sudirman No. 03'],
    ['Bergabung', '17 07 2005'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Akun',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            ..._myData.map((e) {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e[0],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        e[1],
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  Divider()
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
