import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:daily_money/Models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.controller,
    required this.category,
  });

  final AddTransactionsController controller;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = controller.selectedCategory.value?.id == category.id;
      bool isEditing = controller.isEditing.value;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // The Main Chip
          GestureDetector(
            onTap: () {
              // បើ Edit ហាម Select
              if (!isEditing) {
                controller.selectedCategory.value = category;
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12, top: 8), // Top 8 ទុកកន្លែងឱ្យ X
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? Colors.white : Colors.grey[800]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, color: isSelected ? Colors.black : Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(category.name, style: GoogleFonts.poppins(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),

          if (isEditing)
            Positioned(
              top: 0,
              right: 5,
              child: GestureDetector( 
                onTap: () => controller.deleteCategory(category.id, category.name),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      );
    });
  }
}

