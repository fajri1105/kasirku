import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sop_app/helper/converter_helper.dart';
import 'package:sop_app/models/order.dart';
import 'package:sop_app/models/order_item.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/provider/order_item_provider.dart';
import 'package:sop_app/provider/order_provider.dart';
import 'package:sop_app/provider/product_provider.dart';

class OrderHistory extends StatefulWidget {
  static const routeName = '/order-history';

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderProvider? _orderProvider;
  OrderItemProvider? _orderItemProvider;
  ProductProvider? _productProvider;
  List<Order> _myOrders = [];
  List<OrderItem> _myOrderItems = [];
  List<Product> _myProducts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _orderItemProvider = Provider.of<OrderItemProvider>(context, listen: false);
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (_myOrders.isEmpty) {
      _loadOrder();
    }
  }

  Future<void> _loadOrder() async {
    await _orderProvider?.loadOrder();
    await _orderItemProvider?.loadOrder();
    setState(() {
      _myOrders = _orderProvider?.orders ?? [];
      _myOrderItems = _orderItemProvider?.orderItems ?? [];
      _myProducts = _productProvider?.products ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Riwayat Penjualan',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: _myOrders.length,
          itemBuilder: (context, i) {
            List<OrderItem> _currentItems = _myOrderItems
                .where((e) => e.orderId == _myOrders[i].id)
                .toList();
            return Column(
              children: [
                ListTile(
                  title: Text(
                    ConverterHelper.toRupiah(_myOrders[i].total),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.red),
                  ),
                  subtitle: Text(ConverterHelper.toDate(
                      _myOrders[i].createdAt ?? '1970-01-01T00:00:00.000000Z')),
                ),
                ..._currentItems.map((e) {
                  String title =
                      _myProducts.firstWhere((p) => p.id == e.productId).title;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(e.quantity.toString()),
                            SizedBox(
                              width: 10,
                            ),
                            Text(title),
                          ],
                        ),
                        Text(ConverterHelper.toRupiah(e.subTotal))
                      ],
                    ),
                  );
                }),
                Divider()
              ],
            );
          }),
    );
  }
}
