import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:daily_money/Models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final username = "User".obs;
  final profileImage = "".obs;

  final totalBalance = 0.0.obs;
  final dailyincome = 0.0.obs;
  final dailyexpense = 0.0.obs;
  final isBalanceHidden = false.obs;

  final selectedDate = DateTime.now().obs;
  final recentTransactions = <Transaction>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    fetchTransactions();
  }

  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userMetadata = user.userMetadata;
      if (userMetadata != null) {
        username.value = userMetadata['full_name'] ?? 'No Name';
        profileImage.value = userMetadata['avatar_url'] ?? '';
      }
    }
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

      recentTransactions.value = data
          .map((json) => Transaction.fromJson(json))
          .toList();

      _calculateBalance();
    } catch (e) {
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
    dailyincome.value = income;
    dailyexpense.value = expense;
    totalBalance.value = income - expense;
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await Supabase.instance.client
          .from('transactions')
          .delete()
          .eq('id', transactionId);

      recentTransactions.removeWhere((tx) => tx.id == transactionId);
      _calculateBalance();

      if (Get.isRegistered<StatisticsController>()) {
        Get.find<StatisticsController>().fetchStatistics();
      }

      Get.snackbar(
        "Success",
        "Transaction deleted successfully.",
        backgroundColor: Colors.green,

        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong while deleting transaction.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> clearAllTransactions() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      await Supabase.instance.client
          .from('transactions')
          .delete()
          .eq('user_id', user.id);

      recentTransactions.clear();

      totalBalance.value = 0.0;
      dailyincome.value = 0.0;
      dailyexpense.value = 0.0;

      if (Get.isRegistered<StatisticsController>()) {
        Get.find<StatisticsController>().fetchStatistics();
      }

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
