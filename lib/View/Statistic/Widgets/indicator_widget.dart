import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:daily_money/View/Statistic/Widgets/indicator.dart';
import 'package:flutter/material.dart';

class IndicatorsWidget extends StatelessWidget {
  const IndicatorsWidget({
    super.key,
    required this.controller,
    required this.context,
  });

  final StatisticsController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.red, Colors.amber, Colors.teal, Colors.indigo];
    final categories = controller.pieChartData.keys.toList();
    if (categories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(categories.length, (index) {
        return Indicator(
          context: context,
          color: colors[index % colors.length],
          text: categories[index],
        );
      }),
    );
  }
}


