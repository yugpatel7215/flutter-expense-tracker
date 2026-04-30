import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';
import 'package:expense_tracker/features/expenses/model/transaction_model.dart';
import 'package:expense_tracker/features/expenses/screen/EditTransaction.dart';
import 'package:expense_tracker/features/expenses/screen/TransactionDetailScreen.dart';
import 'package:expense_tracker/features/expenses/Palette/palettes.dart'; // Import your global palette
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final transactions = provider.transactions;

        if (transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: Palette.textSecondary.withOpacity(0.2),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No transactions yet!",
                  style: TextStyle(color: Palette.textSecondary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        // Using separated for clean spacing between tiles
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final isIncome = transaction.type == TransactionType.income;
            final typeColor = isIncome ? Palette.income : Palette.expense;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TransactionDetailScreen(transaction: transaction),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Palette.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Palette.border, width: 1),
                ),
                child: Row(
                  children: [
                    // ── Leading Icon Container ──
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isIncome
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: typeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // ── Category & Date ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category,
                            style: const TextStyle(
                              color: Palette.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMd().format(transaction.dateTime),
                            style: const TextStyle(
                              color: Palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Amount & Actions ──
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isIncome ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _SmallActionButton(
                              icon: Icons.edit_rounded,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditTransaction(transaction: transaction),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _SmallActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: Palette.expense.withOpacity(0.7),
                              onTap: () =>
                                  _showDeleteDialog(context, transaction),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Palette.border),
        ),
        title: const Text(
          "Delete Transaction",
          style: TextStyle(
            color: Palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure? This will update your balance.",
          style: TextStyle(color: Palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final provider = context.read<TransactionProvider>();
              final int deletedIndex = provider.transactions.indexOf(
                transaction,
              );
              provider.deleteTransaction(transaction);
              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Palette.card,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Text(
                    "Transaction deleted",
                    style: TextStyle(color: Palette.textPrimary),
                  ),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Palette.gold,
                    onPressed: () =>
                        provider.insertTransaction(deletedIndex, transaction),
                  ),
                ),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Palette.expense,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Action Button Styled for the Theme ──
class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _SmallActionButton({
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Palette.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Palette.border),
        ),
        child: Icon(icon, size: 14, color: color ?? Palette.gold),
      ),
    );
  }
}
