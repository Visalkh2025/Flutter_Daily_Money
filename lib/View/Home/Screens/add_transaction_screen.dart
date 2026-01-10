import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:daily_money/Models/category_model.dart';
import 'package:daily_money/View/Profile/category.dart' as category_screen;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  final controller = Get.put(AddTransactionsController());

  AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.isExpense.value ? "Add Expense" : "Add Income",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Switch Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildTypeTab("Expense", true),
                  _buildTypeTab("Income", false),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Amount Input
            Center(
              child: Column(
                children: [
                  Text("Amount", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("\$ ", style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey)),
                      IntrinsicWidth(
                        child: TextField(
                          controller: controller.amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                            hintStyle: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Category Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                
                // 🔥 ប៊ូតុង Edit Mode
                Obx(() => GestureDetector(
                  onTap: () => controller.toggleEditMode(),
                  child: Text(
                    controller.isEditing.value ? "Done" : "Edit",
                    style: GoogleFonts.poppins(
                      color: controller.isEditing.value ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),

            // 🔥 Category List with Edit Support
            SizedBox(
              height: 60, // ដាក់កំពស់ឱ្យរាងធំបន្តិចកុំឱ្យដាច់ក្បាល X
              child: Obx(() {
                final isExpense = controller.isExpense.value;
                final filteredCategories = controller.categories
                    .where((cat) => cat.type == (isExpense ? 'expense' : 'income'))
                    .toList();

                return ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none, // អនុញ្ញាតឱ្យប៊ូតុង X លៀនចេញក្រៅបាន
                  children: [
                    ...filteredCategories.map((cat) => _buildCategoryChip(cat)),
                    _buildAddButton(),
                  ],
                );
              }),
            ),

            const SizedBox(height: 30),

            // 4. Note Input
            Text("Note", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.noteController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: "e.g., Lunch at Cafe",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),

            // 5. Date Picker
            Text("Date", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
                );
                if (picked != null) controller.selectDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Obx(() => Text(DateFormat('dd MMMM yyyy').format(controller.selectDate.value), style: GoogleFonts.poppins(color: Colors.white))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // 6. Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isExpense.value ? const Color(0xFFF87171) : const Color(0xFF4ADE80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Save Transaction", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildTypeTab(String title, bool isExpenseTab) {
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

  // 🔥 Modified Category Chip with Delete Button (X)
  Widget _buildCategoryChip(CategoryModel category) {
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

          // 🔥 The Delete (X) Button - Only shows when Editing
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

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () async {
        // 🔥 កែត្រង់នេះ៖ បញ្ជូន isExpense: controller.isExpense.value ទៅ
        final result = await Get.to(() => category_screen.Category(
          // បើមិនដាក់បន្ទាត់នេះទេ វានឹងជាប់ Expense រហូត!
          isExpense: controller.isExpense.value, 
        ));

        if (result == true) {
          controller.fetchCategories();
        }
      },
      child: Container(
        // ... (កូដ UI ខាងក្នុងនៅដដែល) ...
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