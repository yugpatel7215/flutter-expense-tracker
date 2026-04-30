import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── DESIGN TOKENS (Shared across app) ───────────────────────────────────────
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

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == TransactionType.income;
    final Color typeColor = isIncome ? _Palette.income : _Palette.expense;

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
          "Transaction Details",
          style: TextStyle(
            color: _Palette.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // ─── HERO AMOUNT SECTION ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: _Palette.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _Palette.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded,
                      color: typeColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      color: _Palette.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isIncome ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: _Palette.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── DETAILS LIST ───
            Container(
              decoration: BoxDecoration(
                color: _Palette.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _Palette.border),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.calendar_today_rounded,
                    "Date & Time",
                    DateFormat(
                      'EEEE, dd MMM yyyy',
                    ).format(transaction.dateTime),
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    Icons.layers_rounded,
                    "Type",
                    transaction.type.name.toUpperCase(),
                    valueColor: typeColor,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    Icons.description_rounded,
                    "Description",
                    transaction.description?.isNotEmpty == true
                        ? transaction.description!
                        : "No notes added",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: _Palette.border.withOpacity(0.5),
      indent: 65,
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _Palette.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _Palette.border),
            ),
            child: Icon(icon, color: _Palette.gold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _Palette.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? _Palette.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
