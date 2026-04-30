import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';
import 'package:expense_tracker/features/expenses/Palette/palettes.dart';
import 'package:expense_tracker/features/expenses/screen/AddExpesneScreen.dart';
import 'package:expense_tracker/features/expenses/screen/AnalyticsScreen.dart';

import 'package:expense_tracker/features/expenses/utility/Transaction_Tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const _HomeContent(), const AnalyticsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── HOME CONTENT ───────────────────────────────────────────────────────────
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: Palette.bg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Palette.gold, Color(0xFFE8A020)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.currency_rupee,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Expense Tracker',
                  style: TextStyle(
                    color: Palette.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),

          // ── Balance Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Consumer<TransactionProvider>(
                builder: (context, provider, _) {
                  return _BalanceCard(
                    balance: provider.balance,
                    income: provider.totalIncome,
                    expense: provider.totalExpense,
                  );
                },
              ),
            ),
          ),

          // ── Section Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Palette.gold.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Transaction List ──
          const SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TransactionTile(),
            ),
          ),
        ],
      ),
      floatingActionButton: _PremiumFAB(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, anim, __) => const AddTransactionScreen(),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── INTERNAL WIDGETS (To solve missing reference errors) ───────────────────

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const _BalanceCard({
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Palette.border),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL BALANCE',
            style: TextStyle(
              color: Palette.textSecondary,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Palette.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'INCOME',
                amount: income,
                color: Palette.income,
                isIncome: true,
              ),
              _StatItem(
                label: 'EXPENSE',
                amount: expense,
                color: Palette.expense,
                isIncome: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isIncome;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Palette.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Palette.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Palette.surface,
      selectedItemColor: Palette.gold,
      unselectedItemColor: Palette.textSecondary,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Analytics',
        ),
      ],
    );
  }
}

class _PremiumFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const _PremiumFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Palette.gold, Color(0xFFE8A020)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Palette.gold.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 32),
      ),
    );
  }
}
