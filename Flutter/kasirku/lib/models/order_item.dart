import 'package:hive/hive.dart';

part 'order_item.g.dart'; 

@HiveType(typeId: 3)
class OrderItem {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int productId;
  @HiveField(2)
  int? orderId;
  @HiveField(3)
  int price;
  @HiveField(4)
  int quantity;
  @HiveField(5)
  int subTotal;

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.subTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        id: json['id'],
        orderId: json['order_id'],
        productId: json['product_id'],
        price: json['price'],
        quantity: json['quantity'],
        subTotal: json['sub_total']);
  }
   Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'price': price,
      'quantity': quantity,
      'sub_total': subTotal,
    };
  }
}
