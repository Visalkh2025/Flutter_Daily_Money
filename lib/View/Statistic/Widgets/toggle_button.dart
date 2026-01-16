import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.controller,
    required this.context,
    required this.title,
    required this.value,
  });

  final StatisticsController controller;
  final BuildContext context;
  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleExpense(value),
        child: Obx(() {
          final isSelected = controller.isExpense.value == value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (value ? Colors.redAccent : Colors.greenAccent)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }
}
