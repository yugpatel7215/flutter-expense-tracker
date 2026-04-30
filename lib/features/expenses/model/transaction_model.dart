import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final TransactionType type;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final DateTime dateTime;

  TransactionModel({
    required this.amount,
    required this.category,
    required this.type,
    required this.description,
    required this.dateTime,
  });
}
