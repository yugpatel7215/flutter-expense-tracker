import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:hive/hive.dart';

class TransactionRepository {
  final Box<TransactionModel> _box;

  TransactionRepository(this._box);

  // Fetch all
  List<TransactionModel> getAllTransactions() {
    return _box.values.toList();
  }

  // Save
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _box.add(transaction);
  }

  // Delete
  Future<void> deleteTransaction(int id) async {
    await _box.delete(id);
  }
}
