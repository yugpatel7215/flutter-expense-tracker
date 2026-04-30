import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/features/expenses/Provider/Transaction_Provider.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key});

  static final List<Color> categoryColors = [
    const Color(0xFF6750A4), // Deep Purple
    const Color(0xFFFFB74D), // Orange
    const Color(0xFF4FC3F7), // Light Blue
    const Color(0xFFE57373), // Red/Pink
    const Color(0xFF81C784), // Green
    const Color(0xFFBA68C8), // Purple
    const Color(0xFF64B5F6), // Blue
    const Color(0xFFFFD54F), // Yellow
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, expenseProvider, _) {
        final categoryTotals = expenseProvider.sortedCategoryTotals;

        if (categoryTotals.isEmpty) {
          return const Center(child: Text('No expense data to display'));
        }

        return PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            sections: _buildSections(categoryTotals),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(
    List<MapEntry<String, double>> data,
  ) {
    int index = 0;
    return data.map((entry) {
      final color = categoryColors[index % categoryColors.length];
      index++;

      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        radius: 60,
        color: color,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
