import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 2)
class Order {
  @HiveField(0)
  int id;
  @HiveField(1)
  int total;
  @HiveField(2)
  String method;
  @HiveField(3)
  String createdAt;

  Order(
      {required this.id,
      required this.total,
      required this.method,
      required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        total: json['total'],
        method: json['method'],
        createdAt: json['created_at']);
  }
  
}
