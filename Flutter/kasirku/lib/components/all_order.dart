import 'package:flutter/material.dart';

class AllOrder extends StatefulWidget {
  String menuType = '';
  AllOrder({required this.menuType});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  List<String> myList = [];

  @override
  void initState() {
    super.initState();
    if (widget.menuType == 'all') {
      myList = ['all', 'cek', 'lhi', 'ada', 'lagi'];
    } else if (widget.menuType == 'pending') {
      myList = ['pending'];
    } else if (widget.menuType == 'shipped') {
      myList = ['shipped', 'juga'];
    } else if (widget.menuType == 'completed') {
      myList = ['complete', 'juga', 'lagi'];
    } else if (widget.menuType == 'cancled') {
      myList = ['cancle', 'juga', 'lagi', 'ada'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: myList.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.orange.shade300),
                    child: Column(
                      children: [
                        Text(
                          'Nama Toko',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Text(
                          'Menunggu Konfirmasi Pembayaran oleh Penjual',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ...myList.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Judul Makanan', style: TextStyle(fontSize: 16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rp30.000'),
                              Text('3'),
                              Text('Rp90.000'),
                            ],
                          ),
                          Divider(
                            height: 2,
                          ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '17/05/2025',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Rp4000.000',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
