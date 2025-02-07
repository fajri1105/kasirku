import 'package:hive/hive.dart';

part 'transaction_history.g.dart'; 

@HiveType(typeId: 4)
class TransactionHistory {
  @HiveField(0)
  int userId;
  @HiveField(1)
  int total;
  @HiveField(2)
  int createdAt;

  TransactionHistory({
    required this.userId,
    required this.total,
    required this.createdAt,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
        userId: json['user_id'],
        total: json['total'],
        createdAt: json['created_at']);
  }
}
