import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/my_env.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product>? _products;
  List<Product>? get products => _products;

  Future<void> getProducts() async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/products');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': MyEnv.token ?? '',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        print(result['data']['products']);
        if (result['data'] != null && result['data']['products'] != null) {
          _products = (result['data']['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
          notifyListeners();
        } else {
          throw 'Data produk tidak ditemukan';
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Product> newProduct(String title, int price, File image) async {
    Uri url = Uri.parse(MyEnv.apiUrl + '/product');

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': MyEnv.token ?? '',
    };

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      request.fields['title'] = title;
      request.fields['price'] = price.toString();
      request.fields['description'] = '-';
      request.fields['category'] = '-';
      request.fields['stock'] = '-';

      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['status'] == true) {
          return responseData['data']['product'];
        }
      }
      throw 'Gagal menambahkan produk!';
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
