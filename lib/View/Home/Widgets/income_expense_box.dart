import 'package:daily_money/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IncomeExpenseBox extends StatelessWidget {
  const IncomeExpenseBox({
    super.key,
    required this.controller,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final HomeController controller;
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 11)),
              Obx(() => Text(
                    controller.isBalanceHidden.value
                        ? "••••"
                        : NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                            .format(amount),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
