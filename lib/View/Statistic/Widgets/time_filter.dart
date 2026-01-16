import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TimeFilter extends StatelessWidget {
  const TimeFilter({
    super.key,
    required this.controller,
    required this.context,
  });

  final StatisticsController controller;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: controller.periods.map((period) {
        return GestureDetector(
          onTap: () => controller.changePeriod(period),
          child: Obx(() {
            bool isSelected = controller.currentPeriod.value == period;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                period,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}


