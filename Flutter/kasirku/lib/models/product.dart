import 'package:hive/hive.dart';

part 'product.g.dart'; 

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  int id;
  @HiveField(1)
  int userId;
  @HiveField(2)
  String title;
  @HiveField(3)
  int price;
  @HiveField(4)
  String photoUrl;
  @HiveField(5)
  int stock;


  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.price,
    required this.photoUrl,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id : json['id'],
      userId : json['user_id'],
      title : json['title'],
      price : json['price'],
      photoUrl : json['photo_url'],
      stock : json['stock'],
    );
  }
}
