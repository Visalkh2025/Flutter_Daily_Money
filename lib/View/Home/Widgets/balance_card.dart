import 'package:daily_money/Controllers/home_controller.dart';
import 'package:daily_money/View/Home/Widgets/income_expense_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class balancecard extends StatelessWidget {
  const balancecard({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // Total Balance Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Balance", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14)),
              Obx(() => GestureDetector(
                onTap: () => controller.toggleBalanceHide(),
                child: Icon(
                  controller.isBalanceHidden.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                  size: 20,
                ),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.isBalanceHidden.value
                ? "••••••••"
                : NumberFormat.currency(symbol: "\$", decimalDigits: 2).format(controller.totalBalance.value),
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          )),
          const SizedBox(height: 24),
          
          Obx(() => Row(
            children: [
              Expanded(
                child: IncomeExpenseBox(controller: controller, title: "Income", amount: controller.dailyincome.value, icon: Icons.arrow_upward, color: const Color(0xFF4ADE80), bgColor: const Color(0xFF4ADE80).withOpacity(0.2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: IncomeExpenseBox(controller: controller, title: "Expense", amount: controller.dailyexpense.value, icon: Icons.arrow_downward, color: const Color(0xFFF87171), bgColor: const Color(0xFFF87171).withOpacity(0.2)),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

