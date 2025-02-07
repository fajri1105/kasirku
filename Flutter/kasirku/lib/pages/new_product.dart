import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sop_app/helper/converter_helper.dart';
import 'package:sop_app/main.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/provider/product_provider.dart';

class NewProduct extends StatefulWidget {
  static const routeName = '/new-product';

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> fields = [];
  Product? _product;
  String? _error;
  bool _isLoading = false;
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600, // Mengatur ukuran maksimum gambar
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendData() async {
    setState(() {
      _isLoading = true;
    });
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Tidak boleh ada kolom yang kosong';
      });
      return;
    }
    try {
      ProductProvider _productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final newProduct = await _productProvider.newProduct(
          _titleController.text,
          int.parse(_priceController.text),
          _selectedImage ?? File('assets/images/default.png'));
      setState(() {
        _product = newProduct;
        _isLoading = false;
      });
      return;
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fields = [
      {
        'title': 'Judul Produk',
        'controller': _titleController,
        'obsecure': false,
        'keyboardType': TextInputType.name,
        'icon': Icons.title,
      },
      {
        'title': 'Harga',
        'controller': _priceController,
        'obsecure': false,
        'keyboardType': TextInputType.number,
        'icon': Icons.money,
      },
    ];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.red,
          title: Text(
            'Produk Baru',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
        body: (_product == null)
            ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_selectedImage != null)
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Text("Belum ada gambar yang dipilih"),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red.shade400)),
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Galeri",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => _pickImage(ImageSource.gallery),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red.shade400)),
                          icon: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          label: Text("Kamera",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () => _pickImage(ImageSource.camera),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    if (_error != null)
                      Text(
                        _error ?? '',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
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
                              _sendData();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 25),
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "Tambahkan",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
              )
            : Center(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Berhasil Menambahkan Produk Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.network(
                          _product?.photoUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        _product?.title ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        ConverterHelper.toRupiah(_product?.price ?? 0),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _product = null;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red)),
                          child: Text(
                            'Tutup',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ));
  }
}
