import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  // 🛠️ FIX: ប្រើ Get.put ជំនួស Get.find
  final controller = Get.put(AddTransactionsController());

  AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Matte Black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.isExpense.value ? "Add Expense" : "Add Income",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        )),
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
            Text("Amount", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                prefixText: "\$ ",
                prefixStyle: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.grey),
                border: InputBorder.none,
                hintText: "0.00",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 30),

            // 3. Category Chips
            Text("Category", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: (controller.isExpense.value ? controller.expenseCategories : controller.incomeCategories)
                  .map((cat) => _buildCategoryChip(cat))
                  .toList(),
            )),
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
                  builder: (context, child) {
                    return Theme(data: ThemeData.dark(), child: child!);
                  },
                );
                if (picked != null) controller.selectDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Obx(() => Text(
                      DateFormat('dd MMMM yyyy').format(controller.selectDate.value),
                      style: GoogleFonts.poppins(color: Colors.white),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // 6. Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isExpense.value ? const Color(0xFFF87171) : const Color(0xFF4ADE80),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Save Transaction", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              )),
            ),
          ],
        ),
      ),
    );
  }

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
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return GestureDetector(
      onTap: () => controller.selectCategory.value = category,
      child: Obx(() {
        bool isSelected = controller.selectCategory.value == category;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey[800]!),
          ),
          child: Text(
            category,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.black : Colors.grey[400],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }
}