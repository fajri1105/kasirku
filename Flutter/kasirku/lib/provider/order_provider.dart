import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sop_app/models/order.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/my_env.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Future<void> loadOrder() async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/orders');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': MyEnv.token ?? '',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data'] != null &&
            responseData['data']['orders'] != null) {
          _orders = (responseData['data']['orders'] as List)
              .map((json) => Order.fromJson(json))
              .toList();
          notifyListeners();
          return;
        }
      }
      throw 'Gagal memuat data!';
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createOrder(String method, int total) async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/order');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': MyEnv.token ?? '',
    };
    final body = json.encode({'method': method, 'total': total});
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          Order orderData = Order.fromJson(responseData['data']['order']);
          return orderData.id;
        }
      }
      throw 'Gagal membuat pesanan!';
    } catch (e) {
      rethrow;
    }
  }
}
