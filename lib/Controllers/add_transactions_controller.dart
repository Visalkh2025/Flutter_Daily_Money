import 'package:daily_money/Models/category_model.dart';
import 'package:daily_money/Models/default_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_money/Controllers/home_controller.dart';


class AddTransactionsController extends GetxController {
  // 1. Variables
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final selectDate = DateTime.now().obs;
  
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final isExpense = true.obs; 
  final isLoading = false.obs;
  final RxList<CategoryModel> categories = RxList<CategoryModel>();

  // Default categories
  final List<DefaultCategory> defaultExpenseCategories = [
    DefaultCategory(name: 'Food', icon: Icons.fastfood),
    DefaultCategory(name: 'Transport', icon: Icons.directions_car),
    DefaultCategory(name: 'Shopping', icon: Icons.shopping_bag),
    DefaultCategory(name: 'Bills', icon: Icons.receipt_long),
    DefaultCategory(name: 'Entertainment', icon: Icons.movie),
    DefaultCategory(name: 'Health', icon: Icons.medical_services),
  ];

  final List<DefaultCategory> defaultIncomeCategories = [
    DefaultCategory(name: 'Salary', icon: Icons.account_balance_wallet),
    DefaultCategory(name: 'Freelance', icon: Icons.laptop_mac),
    DefaultCategory(name: 'Gift', icon: Icons.card_giftcard),
    DefaultCategory(name: 'Invest', icon: Icons.trending_up),
  ];


  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      
      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .from('categories')
          .select()
          .eq('user_id', user.id);

      if (data.isNotEmpty) {
        categories.value = data.map((e) => CategoryModel.fromMap(e)).toList();
        // Set default category
        filterCategories();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  void filterCategories() {
    final filtered = categories
        .where((c) => c.type == (isExpense.value ? 'expense' : 'income'))
        .toList();
    if (filtered.isNotEmpty) {
      selectedCategory.value = filtered.first;
    } else {
      selectedCategory.value = null;
    }
  }

  void toggleType(bool value) {
    isExpense.value = value;
    filterCategories();
  }

  // 3. Save Function
  Future<void> saveTransaction() async {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter amount", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar("Error", "Please select a category", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return; 
      }

      final double amount = double.parse(amountController.text);

      // Save to Supabase
      await Supabase.instance.client.from('transactions').insert({
        'user_id': user.id,
        'amount': amount,
        'title': noteController.text, // Note
        'category': selectedCategory.value!.name,
        'date': selectDate.value.toIso8601String(),
        'type': isExpense.value ? 'expense' : 'income',
      });

      // 4. បិទផ្ទាំង Add និងបង្ហាញ Success
      Get.back();
      Get.snackbar("Success", "Transaction added", backgroundColor: Colors.green, colorText: Colors.white);
      
      // 🔥🔥🔥 UPDATE: បញ្ជាឱ្យ Home Screen ទាញទិន្នន័យថ្មីភ្លាមៗ
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchTransactions();
      }

    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
      print("Error saving: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}