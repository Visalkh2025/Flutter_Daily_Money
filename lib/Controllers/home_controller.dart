import 'package:daily_money/Models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  // User Info
  final username = "Khem Visal".obs; // អ្នកអាចទាញពី Profile Table ពេលក្រោយ
  final profileImage = "https://i.pravatar.cc/150?img=12".obs;

  // Balance Logic
  final totalBalance = 0.0.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpense = 0.0.obs;
  final isBalanceHidden = false.obs;

  // UI State
  final selectedDate = DateTime.now().obs;
  final recentTransactions = <Transaction>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void toggleBalanceHide() => isBalanceHidden.value = !isBalanceHidden.value;

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // 1. ទាញទិន្នន័យពី Supabase
      final from = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
      );
      final to = from.add(const Duration(days: 1));
      final response = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .gte('date', from.toIso8601String())
          .lt('date', to.toIso8601String())
          .order('date', ascending: false);

      final data = response as List;

      // 2. បំប្លែងទៅជា Model (ប្រើកូដថ្មីក្នុង Model)
      recentTransactions.value = data
          .map((json) => Transaction.fromJson(json))
          .toList();

      // 3. គណនាលុយ (Income, Expense, Total)
      _calculateBalance();
    } catch (e) {
      print("Error fetching transactions: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while fetching data.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateBalance() {
    double income = 0.0;

    double expense = 0.0;

    for (var tx in recentTransactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    // Update ចូល UI

    monthlyIncome.value = income;

    monthlyExpense.value = expense;

    totalBalance.value = income - expense;
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await Supabase.instance.client
          .from('transactions')
          .delete()
          .eq('id', transactionId);

      // Remove from local list to avoid re-fetch, for faster UI update

      recentTransactions.removeWhere((tx) => tx.id == transactionId);

      _calculateBalance(); // Recalculate balance after removal

      Get.snackbar(
        "Success",

        "Transaction deleted successfully.",

        backgroundColor: Colors.green,

        colorText: Colors.white,
      );
    } catch (e) {
      print("Error deleting transaction: $e");

      Get.snackbar(
        "Error",

        "Something went wrong while deleting transaction.",

        backgroundColor: Colors.redAccent,

        colorText: Colors.white,
      );
    }
  }
  // នៅក្នុង HomeController

  Future<void> clearAllTransactions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // 1. លុបពី Supabase (លុបតែរបស់ User នេះប៉ុណ្ណោះ)
      await Supabase.instance.client
          .from('transactions')
          .delete()
          .eq('user_id', user.id); // 🔥 សំខាន់ណាស់! ហាមភ្លេច user_id

      // 2. លុបពី List ក្នុង App
      recentTransactions.clear();

      // 3. Reset លុយឱ្យទៅជា 0.00 ទាំងអស់
      totalBalance.value = 0.0;
      monthlyIncome.value = 0.0;
      monthlyExpense.value = 0.0;

      Get.snackbar(
        "Success",
        "All transactions have been deleted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to clear data: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
