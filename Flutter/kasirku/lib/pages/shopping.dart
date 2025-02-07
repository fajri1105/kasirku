import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sop_app/helper/converter_helper.dart';
import 'package:sop_app/models/order_item.dart';
import 'package:sop_app/models/product.dart';
import 'package:sop_app/provider/order_item_provider.dart';
import 'package:sop_app/provider/order_provider.dart';
import 'package:sop_app/provider/product_provider.dart';

class Shopping extends StatefulWidget {
  static const routeName = '/shopping';

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  bool _isLoading = false;
  bool _orderSuccess = false;
  List<Product> _myProducts = [];
  List<OrderItem> _orderItem = [];
  ProductProvider? _productProvider = null;
  OrderProvider? _orderProvider = null;
  OrderItemProvider? _orderItemProvider = null;
  int total = 0;
  int _itemCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_productProvider == null) {
      _productProvider = Provider.of<ProductProvider>(context, listen: false);
      _fetchProducts();
    }
    if (_orderProvider == null) {
      _orderProvider = Provider.of<OrderProvider>(context, listen: false);
      _fetchProducts();
    }
    if (_orderItemProvider == null) {
      _orderItemProvider =
          Provider.of<OrderItemProvider>(context, listen: false);
      _fetchProducts();
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_productProvider?.products == null) {
        await _productProvider?.getProducts();
      }
      setState(() {
        _myProducts = _productProvider?.products ?? [];
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String method = 'cash';
      int? orderId = await _orderProvider?.createOrder(method, total);
      await _orderItemProvider?.createOrder(orderId ?? -99, _orderItem);
      setState(() {
        _orderSuccess = true;
        total = 0;
        _orderItem.clear();
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(''),
        // TextField(
        //   textInputAction: TextInputAction.search,
        //   autofocus: false,
        //   decoration: InputDecoration(
        //     contentPadding:
        //         EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        //     border: OutlineInputBorder(
        //         borderSide: BorderSide.none,
        //         borderRadius: BorderRadius.circular(30)),
        //     fillColor: const Color.fromARGB(255, 247, 173, 168),
        //     filled: true,
        //   ),
        // ),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.search,
        //         color: Colors.white,
        //         size: 30,
        //       )),
        //   SizedBox(
        //     width: 10,
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : !_orderSuccess
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 6 / 10),
                    itemCount: _myProducts.length,
                    itemBuilder: (contect, i) {
                      OrderItem? _orderItemProduct = _orderItem.firstWhere(
                          (item) => item.productId == _myProducts[i].id,
                          orElse: () => OrderItem(
                              productId: -1,
                              price: 0,
                              quantity: 0,
                              subTotal: 0));
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(_myProducts[i].photoUrl),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _myProducts[i].title,
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      _myProducts[i].price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 17),
                                    ),
                                    _orderItemProduct.productId == -1
                                        ? TextButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder: (BuildContext
                                                              context,
                                                          StateSetter
                                                              modalSetState) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                height: 100,
                                                                width: 100,
                                                                child: Image.network(
                                                                    _myProducts[
                                                                            i]
                                                                        .photoUrl),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                _myProducts[i]
                                                                    .title,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (_itemCount <=
                                                                              0) {
                                                                            _itemCount =
                                                                                0;
                                                                          } else
                                                                            _itemCount--;
                                                                          modalSetState(
                                                                              () {});
                                                                        });
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.red)),
                                                                      icon: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                  Text(
                                                                    _itemCount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _itemCount++;
                                                                          modalSetState(
                                                                              () {});
                                                                        });
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.red)),
                                                                      icon: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    int _subTotal =
                                                                        _itemCount *
                                                                            _myProducts[i].price;
                                                                    setState(
                                                                        () {
                                                                      _orderItem.add(OrderItem(
                                                                          productId: _myProducts[i]
                                                                              .id,
                                                                          price: _myProducts[i]
                                                                              .price,
                                                                          quantity:
                                                                              _itemCount,
                                                                          subTotal:
                                                                              _subTotal));
                                                                      total +=
                                                                          _subTotal;
                                                                      _itemCount =
                                                                          0;
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          WidgetStatePropertyAll(
                                                                              Colors.red)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Tambahkan',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Colors.red)),
                                            child: Center(
                                              child: Text(
                                                'Tambahkan',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ))
                                        : Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (_orderItemProduct
                                                                .quantity <=
                                                            0) {
                                                          _itemCount = 0;
                                                        } else
                                                          _orderItemProduct
                                                              .quantity--;
                                                        total -= _myProducts[i]
                                                            .price;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                Colors.red)),
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    )),
                                                Text(
                                                  _orderItemProduct.quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _orderItemProduct
                                                            .quantity++;
                                                        total += _myProducts[i]
                                                            .price;
                                                      });
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                Colors.red)),
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                : Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Berhasil menambahkan pesanan!',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _orderSuccess = false;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.red)),
                                child: Text(
                                  'Tutup',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: _orderItem.length != 0
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    total.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter modalSetState) {
                                      return Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Pesanan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            ..._orderItem.map((e) {
                                              String title = _myProducts
                                                  .firstWhere((p) =>
                                                      p.id == e.productId)
                                                  .title;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    title,
                                                  ),
                                                  Text(
                                                    e.quantity.toString(),
                                                  ),
                                                ],
                                              );
                                            }),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total',
                                                ),
                                                Text(ConverterHelper.toRupiah(total),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.red))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  _createOrder();
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.red)),
                                                child: Center(
                                                  child: Text(
                                                    'Pesan',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red)),
                          child: Text(
                            'Pesan',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _orderItem.clear();
                              total = 0;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ))
                    ],
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}
