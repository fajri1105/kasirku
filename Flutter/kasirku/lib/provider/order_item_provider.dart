import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sop_app/models/order.dart';
import 'package:sop_app/models/order_item.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/my_env.dart';
import 'package:http/http.dart' as http;

class OrderItemProvider with ChangeNotifier {
  List<OrderItem> _orderItems = [];
  List<OrderItem> get orderItems => _orderItems;

  Future<void> loadOrder() async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/order-items');
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
            responseData['data']['order_items'] != null) {
          _orderItems = (responseData['data']['order_items'] as List)
              .map((json) => OrderItem.fromJson(json))
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

  Future<bool>? createOrder(int orderId, List<OrderItem> orderItem) async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/order-items');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': MyEnv.token ?? '',
    };
    List<Map<String, dynamic>> orderItemsJson =
        orderItem.map((item) => item.toJson()).toList();
    final body =
        json.encode({'order_id': orderId, 'order_items': orderItemsJson});
    print('masuk tahap request...');
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return true;
        }
      }
      throw json.decode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
