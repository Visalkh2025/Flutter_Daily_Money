import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionsController extends GetxController {
  // 1. Variables
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final selectDate = DateTime.now().obs;
  
  // 🔥 FIX: ដាក់តម្លៃដើមឱ្យវា កុំឱ្យវាទទេ ('')
  final selectCategory = 'Food'.obs; 

  final isExpense = true.obs; 
  final isLoading = false.obs;

  // 2. Categories
  final expenseCategories = ["Food", "Transport", "Shopping", "Bills", "Fun"];
  final incomeCategories = ["Salary", "Freelance", "Gift", "Invest"];

  // 🔥 Initialize: ពេល Controller ចាប់ផ្តើម ឱ្យវារើសយក Category ដំបូងគេ
  @override
  void onInit() {
    super.onInit();
    selectCategory.value = expenseCategories[0];
  }

  void toggleType(bool value) {
    isExpense.value = value;
    selectCategory.value = value ? expenseCategories[0] : incomeCategories[0];
  }

  // 3. Save Function
  Future<void> saveTransaction() async {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter amount", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      // ខ. Get User
      final user = Supabase.instance.client.auth.currentUser;

      // 🔥 FIX 1: ត្រូវ check បែបនេះ។ បើ user == null គឺឈប់ (return)។
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return; 
      }

      // Proceed only if user is NOT null
      final double amount = double.parse(amountController.text);

      // គ. Insert to Supabase
      // ⚠️ Check: ឈ្មោះ Column ក្នុង Supabase ត្រូវឱ្យដូចគ្នា 100% (note vs title?)
      // ... ផ្នែកខាងលើ ...

      // គ. Insert to Table 'transactions'
      // ...
      await Supabase.instance.client.from('transactions').insert({
        'user_id': user.id,
        'amount': amount,
        
        // 🛠️ FIX: ប្តូរពី 'note' ទៅ 'title' ឱ្យដូចក្នុង Database
        'title': noteController.text, 

        'category': selectCategory.value,
        'date': selectDate.value.toIso8601String(),
        'type': isExpense.value ? 'expense' : 'income',
      });
      // ...

      // ... ផ្នែកខាងក្រោម ...

      // ឃ. Success
      Get.back();
      Get.snackbar("Success", "Transaction added", backgroundColor: Colors.green, colorText: Colors.white);
      
      // Update Home Screen (Optional logic logic here later)

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