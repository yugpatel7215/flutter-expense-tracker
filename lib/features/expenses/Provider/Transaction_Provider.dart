import 'package:expense_tracker/features/expenses/Repository/Transaction_Repository.dart';
import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider extends ChangeNotifier {
  // Repository instance used to interact with Hive/database
  final TransactionRepository _repository;

  // Internal list storing all transactions loaded from repository
  List<TransactionModel> _transactions = [];

  // Public read-only access to transactions (prevents external modification)
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  // Constructor: receives repository and loads transactions immediately
  TransactionProvider(this._repository) {
    _loadTransactions();
  }

  // Stores the currently selected month for filtering transactions
  DateTime selectedMonth = DateTime.now();

  // ----------------------------
  // OVERALL TOTALS (ALL TIME)
  // ----------------------------

  // Calculate total income from all stored transactions
  double get totalIncome {
    double total = 0;

    for (var t in _transactions) {
      if (t.type == TransactionType.income) {
        total += t.amount;
      }
    }

    return total;
  }

  // Calculate total expense from all stored transactions
  double get totalExpense {
    double total = 0;

    for (var t in _transactions) {
      if (t.type == TransactionType.expense) {
        total += t.amount;
      }
    }

    return total;
  }

  // Calculate overall balance
  double get balance {
    return totalIncome - totalExpense;
  }

  // ----------------------------
  // DATA LOADING
  // ----------------------------

  // Load all transactions from repository
  void _loadTransactions() {
    _transactions = _repository.getAllTransactions();
    notifyListeners();
  }

  // ----------------------------
  // CRUD OPERATIONS
  // ----------------------------

  // Add new transaction and reload list
  Future<void> addNewTransaction(TransactionModel transaction) async {
    try {
      await _repository.addTransaction(transaction);

      // reload transactions to maintain single source of truth
      _loadTransactions();
    } catch (e) {
      debugPrint("Failed to save transaction: $e");
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(TransactionModel transaction) async {
    try {
      await _repository.deleteTransaction(transaction);

      _transactions.remove(transaction);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to save transaction: $e");
    }
  }

  // Update an existing transaction
  void updateTransaction(TransactionModel oldTx, TransactionModel newTx) {
    final index = _transactions.indexOf(oldTx);

    if (index != -1) {
      _transactions[index] = newTx;
      notifyListeners();
    }
  }

  // Used for undo operations (insert transaction back)
  void insertTransaction(int index, TransactionModel transaction) {
    _transactions.insert(index, transaction);
    notifyListeners();
  }

  // ----------------------------
  // MONTH FILTERING
  // ----------------------------

  // Change the selected month and refresh UI
  void changeMonth(DateTime newMonth) {
    selectedMonth = newMonth;
    notifyListeners();
  }

  // Returns transactions belonging only to the selected month
  List<TransactionModel> get filteredTransactions {
    return _transactions.where((tx) {
      return tx.dateTime.month == selectedMonth.month &&
          tx.dateTime.year == selectedMonth.year;
    }).toList();
  }

  // ----------------------------
  // CATEGORY ANALYSIS (MONTHLY)
  // ----------------------------

  // Calculate total expense for each category in the selected month
  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};

    for (var tx in filteredTransactions) {
      if (tx.type == TransactionType.expense) {
        totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
      }
    }

    return totals;
  }

  // Sort categories by expense amount (largest first)
  List<MapEntry<String, double>> get sortedCategoryTotals {
    return categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  // Calculate income for the selected month
  double get monthlyIncome {
    double total = 0;

    for (var t in filteredTransactions) {
      if (t.type == TransactionType.income) {
        total += t.amount;
      }
    }

    return total;
  }

  // Calculate expense for the selected month
  double get monthlyExpense {
    double total = 0;

    for (var t in filteredTransactions) {
      if (t.type == TransactionType.expense) {
        total += t.amount;
      }
    }

    return total;
  }

  // Balance for the selected month
  double get monthlyBalance {
    return monthlyIncome - monthlyExpense;
  }
}
