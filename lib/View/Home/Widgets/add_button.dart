import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:daily_money/View/Profile/category.dart' as category_screen;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.controller,
  });

  final AddTransactionsController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        
        final result = await Get.to(() => category_screen.Category(
          
          isExpense: controller.isExpense.value, 
        ));

        if (result == true) {
          controller.fetchCategories();
        }
      },
      child: Container(
        
        margin: const EdgeInsets.only(right: 12, top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text("Add Item", style: GoogleFonts.poppins(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}