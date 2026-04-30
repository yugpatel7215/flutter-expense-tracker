import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';
import 'package:expense_tracker/features/expenses/utility/CategoryPiechart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  static const textMuted = Color(0xFF8892A4);
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: _Palette.bg,
      appBar: AppBar(
        backgroundColor: _Palette.bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: _Palette.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final selectedMonth = provider.selectedMonth;
          final categories = provider.sortedCategoryTotals;

          final isCurrentMonth =
              selectedMonth.year == now.year &&
              selectedMonth.month == now.month;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── MONTH SELECTOR ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _MonthSelector(
                    selectedMonth: selectedMonth,
                    isCurrentMonth: isCurrentMonth,
                    onPrev: () => provider.changeMonth(
                      DateTime(selectedMonth.year, selectedMonth.month - 1),
                    ),
                    onNext: () => provider.changeMonth(
                      DateTime(selectedMonth.year, selectedMonth.month + 1),
                    ),
                  ),
                ),
              ),

              // ─── MONTHLY BALANCE CARD ───
              SliverToBoxAdapter(
                child: _MonthlyBalanceCard(amount: provider.monthlyBalance),
              ),

              // ─── PIE CHART SECTION ───
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: _Palette.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _Palette.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Spending Distribution',
                        style: TextStyle(
                          color: _Palette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 220, child: CategoryPieChart()),
                    ],
                  ),
                ),
              ),

              // ─── CATEGORY LIST ───
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = categories[index];
                    return _CategoryTile(label: item.key, amount: item.value);
                  }, childCount: categories.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── HELPER COMPONENTS ───────────────────────────────────────────────────────

class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final bool isCurrentMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.selectedMonth,
    required this.isCurrentMonth,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavCircle(icon: Icons.chevron_left_rounded, onTap: onPrev),
        Container(
          width: 160,
          alignment: Alignment.center,
          child: Text(
            DateFormat('MMMM yyyy').format(selectedMonth),
            style: const TextStyle(
              color: _Palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _NavCircle(
          icon: Icons.chevron_right_rounded,
          onTap: isCurrentMonth ? null : onNext,
          isDisabled: isCurrentMonth,
        ),
      ],
    );
  }
}

class _NavCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _NavCircle({required this.icon, this.onTap, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _Palette.card,
          shape: BoxShape.circle,
          border: Border.all(color: _Palette.border),
        ),
        child: Icon(
          icon,
          color: isDisabled ? _Palette.textMuted : _Palette.gold,
          size: 24,
        ),
      ),
    );
  }
}

class _MonthlyBalanceCard extends StatelessWidget {
  final double amount;
  const _MonthlyBalanceCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = amount >= 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _Palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _Palette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MONTHLY BALANCE',
                style: TextStyle(
                  color: _Palette.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Net Savings',
                style: TextStyle(color: _Palette.textSecondary, fontSize: 13),
              ),
            ],
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isPositive ? _Palette.income : _Palette.expense,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final double amount;

  const _CategoryTile({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Palette.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _Palette.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.category_outlined,
              color: _Palette.gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: _Palette.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: _Palette.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
