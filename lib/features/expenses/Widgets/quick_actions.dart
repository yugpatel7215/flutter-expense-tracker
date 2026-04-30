import 'package:flutter/material.dart';
import 'package:expense_tracker/features/expenses/Palette/palettes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ActionItem> actions = [
      const _ActionItem(
        icon: Icons.add_circle_outline_rounded,
        label: 'Add',
        color: Color(0xFF60A5FA),
      ),
      const _ActionItem(
        icon: Icons.swap_horiz_rounded,
        label: 'Transfer',
        color: Color(0xFFA78BFA),
      ),
      const _ActionItem(
        icon: Icons.pie_chart_outline_rounded,
        label: 'Budget',
        color: Color(0xFF34D399),
      ),
      const _ActionItem(
        icon: Icons.receipt_long_outlined,
        label: 'Bills',
        color: Color(0xFFFBBF24),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) => _QuickActionButton(item: a)).toList(),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _QuickActionButton extends StatelessWidget {
  final _ActionItem item;
  const _QuickActionButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: item.color.withOpacity(0.25)),
          ),
          child: Icon(item.icon, color: item.color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: const TextStyle(
            color: Palette.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
