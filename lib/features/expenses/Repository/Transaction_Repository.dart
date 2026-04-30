import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionRepository {
  // box object
  final Box<TransactionModel> _box;

  TransactionRepository(this._box);

  // add the trancation

  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.add(transaction);
  }

  // fetch or load all the transaction from hive and convert it to list to store in the
  //list

  List<TransactionModel> getAllTransactions() {
    return _box.values.toList(); // convert to list
  }

  //  delete the transaction using  id

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await transaction.delete(); // delete at the specific id
  }

  // update the transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await transaction.save();
  }
}
