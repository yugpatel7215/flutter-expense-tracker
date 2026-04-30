import 'package:flutter/material.dart';
import 'package:expense_tracker/features/expenses/Palette/palettes.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final bool isPositive;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [const Color(0xFF1A2340), const Color(0xFF0F1A2E)]
              : [const Color(0xFF2A1515), const Color(0xFF1A0F0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPositive ? const Color(0xFF2A3A5C) : const Color(0xFF3A2020),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPositive
                ? Colors.blue.withOpacity(0.08)
                : Colors.red.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildBalance(),
          const SizedBox(height: 6),
          Text(
            isPositive
                ? 'Your finances look healthy 🌱'
                : 'You\'re overspending this month',
            style: TextStyle(
              color: isPositive
                  ? Palette.textSecondary
                  : Palette.expense.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Palette.border),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  label: 'Income',
                  value: income,
                  icon: Icons.arrow_downward_rounded,
                  color: Palette.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatPill(
                  label: 'Expenses',
                  value: expense,
                  icon: Icons.arrow_upward_rounded,
                  color: Palette.expense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Palette.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Palette.gold.withOpacity(0.3)),
      ),
      child: const Text(
        'TOTAL BALANCE',
        style: TextStyle(
          color: Palette.gold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildBalance() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            '₹',
            style: TextStyle(color: Palette.textSecondary, fontSize: 22),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          balance.abs().toStringAsFixed(2),
          style: TextStyle(
            color: isPositive ? Palette.textPrimary : Palette.expense,
            fontSize: 42,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Palette.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${value.toStringAsFixed(0)}',
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
