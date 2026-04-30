import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';
import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ─── DESIGN TOKENS (Shared with Home) ────────────────────────────────────────
class _Palette {
  static const bg = Color(0xFF0D0F14);
  static const surface = Color(0xFF161A23);
  static const card = Color(0xFF1E2330);
  static const border = Color(0xFF2A3042);
  static const gold = Color(0xFFF5C842);
  static const income = Color(0xFF34D399);
  static const expense = Color(0xFFFF6B6B);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF8892A4);
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Other",
  ];
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _Palette.gold,
              onPrimary: Colors.black,
              surface: _Palette.surface,
              onSurface: _Palette.textPrimary,
            ),
            dialogBackgroundColor: _Palette.bg,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void saveTransaction() {
    final amountText = _amountController.text.trim();
    final category = _categoryController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty) {
      _showError('Please enter amount');
      return;
    }

    double? enteredAmount = double.tryParse(amountText);
    if (enteredAmount == null) {
      _showError('Please enter a valid number');
      return;
    }

    TransactionType type = _isIncome
        ? TransactionType.income
        : TransactionType.expense;

    final transaction = TransactionModel(
      amount: enteredAmount,
      category: _isIncome ? "Income" : category,
      type: type,
      description: description,
      dateTime: _selectedDate,
    );

    context.read<TransactionProvider>().addNewTransaction(transaction);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: _Palette.expense),
    );
  }

  // Updated Decoration to match Home Screen style
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _Palette.textSecondary, fontSize: 14),
      prefixIcon: Icon(icon, color: _Palette.gold, size: 20),
      filled: true,
      fillColor: _Palette.card,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _Palette.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _Palette.gold, width: 1),
      ),
    );
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
      backgroundColor: _Palette.bg,
      appBar: AppBar(
        backgroundColor: _Palette.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _Palette.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: _Palette.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TYPE TOGGLE ───
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _Palette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _Palette.border),
              ),
              child: Row(
                children: [
                  _TypeButton(
                    label: 'Expense',
                    isSelected: !_isIncome,
                    color: _Palette.expense,
                    onTap: () => setState(() => _isIncome = false),
                  ),
                  _TypeButton(
                    label: 'Income',
                    isSelected: _isIncome,
                    color: _Palette.income,
                    onTap: () => setState(() => _isIncome = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── AMOUNT INPUT ───
            TextField(
              controller: _amountController,
              style: const TextStyle(
                color: _Palette.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _buildInputDecoration(
                'Amount',
                Icons.currency_rupee_rounded,
              ),
            ),
            const SizedBox(height: 16),

            // ─── DATE PICKER ───
            GestureDetector(
              onTap: _presentDatePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _Palette.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _Palette.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: _Palette.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('MMM dd, yyyy').format(_selectedDate),
                      style: const TextStyle(
                        color: _Palette.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.edit_calendar_rounded,
                      color: _Palette.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─── CATEGORY DROPDOWN ───
            if (!_isIncome)
              DropdownButtonFormField<String>(
                dropdownColor: _Palette.surface,
                style: const TextStyle(color: _Palette.textPrimary),
                decoration: _buildInputDecoration(
                  'Category',
                  Icons.grid_view_rounded,
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _categoryController.text = val ?? ''),
              ),
            if (!_isIncome) const SizedBox(height: 16),

            // ─── DESCRIPTION ───
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: _Palette.textPrimary),
              decoration: _buildInputDecoration(
                'Description (Optional)',
                Icons.notes_rounded,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: saveTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _Palette.gold,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Transaction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── HELPER WIDGETS ───────────────────────────────────────────────────────────

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.5) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : _Palette.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
