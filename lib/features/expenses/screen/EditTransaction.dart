import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';
import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransaction({super.key, required this.transaction});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  late final TextEditingController _categoryController;
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late bool _isIncome;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(
      text: widget.transaction.category,
    );
    _amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.transaction.description ?? '',
    );
    _selectedDate = widget.transaction.dateTime;
    _isIncome = widget.transaction.type == TransactionType.income;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.lightBlue[400]),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.lightBlue.shade100, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
      ),
      alignLabelWithHint: true,
    );
  }

  Future<void> _updateTransaction() async {
    final amountText = _amountController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Amount and Category')),
      );
      return;
    }

    final enteredAmount = double.tryParse(amountText);
    if (enteredAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for amount')),
      );
      return;
    }

    final type = _isIncome ? TransactionType.income : TransactionType.expense;

    final updatedTransaction = TransactionModel(
      amount: enteredAmount,
      category: category,
      type: type,
      description: _descriptionController.text.trim(),
      dateTime: _selectedDate,
    );

    context.read<TransactionProvider>().updateTransaction(
      widget.transaction,
      updatedTransaction,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          'Edit Transaction',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _buildInputDecoration('Amount', Icons.attach_money),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _presentDatePicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.lightBlue.shade100,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.lightBlue[400]),
                    const SizedBox(width: 12),
                    Text(
                      'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Text(
                      'Change',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: _buildInputDecoration('Category', Icons.category),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.lightBlue.shade100, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.swap_horiz, color: Colors.lightBlue[400]),
                  const SizedBox(width: 12),
                  const Text(
                    'Type',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    'Expense',
                    style: TextStyle(
                      color: !_isIncome ? Colors.red : Colors.grey,
                    ),
                  ),
                  Switch(
                    activeColor: Colors.lightBlue,
                    value: _isIncome,
                    onChanged: (value) => setState(() => _isIncome = value),
                  ),
                  Text(
                    'Income',
                    style: TextStyle(
                      color: _isIncome ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: _buildInputDecoration(
                'Description',
                Icons.description,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _updateTransaction,
        backgroundColor: Colors.lightBlue[400],
        icon: const Icon(Icons.save),
        label: const Text('UPDATE TRANSACTION'),
      ),
    );
  }
}
