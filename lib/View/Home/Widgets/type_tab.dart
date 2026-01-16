import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class TypeTab extends StatelessWidget {
  const TypeTab({
    super.key,
    required this.controller,
    required this.title,
    required this.isExpenseTab,
  });

  final AddTransactionsController controller;
  final String title;
  final bool isExpenseTab;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleType(isExpenseTab),
        child: Obx(() {
          bool isSelected = controller.isExpense.value == isExpenseTab;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3A3A3C) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey)),
          );
        }),
      ),
    );
  }
}

