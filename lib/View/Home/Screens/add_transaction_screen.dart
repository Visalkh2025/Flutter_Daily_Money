import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:daily_money/View/Home/Widgets/add_button.dart';
import 'package:daily_money/View/Home/Widgets/category_chip.dart';
import 'package:daily_money/View/Home/Widgets/type_tab.dart';
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
                  TypeTab(controller: controller, title: "Expense", isExpenseTab: true),
                  TypeTab(controller: controller, title: "Income", isExpenseTab: false),
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
              height: 60, 
              child: Obx(() {
                final isExpense = controller.isExpense.value;
                final filteredCategories = controller.categories
                    .where((cat) => cat.type == (isExpense ? 'expense' : 'income'))
                    .toList();

                return ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none, 
                  children: [
                    ...filteredCategories.map((cat) => CategoryChip(controller: controller, category: cat)),
                    AddButton(controller: controller),
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
}

