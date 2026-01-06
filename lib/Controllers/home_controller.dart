import 'package:daily_money/Models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  // User Info
  final username = "Khem Visal".obs;
  final profileImage = "https://i.pravatar.cc/150?img=12".obs;

  // Balance Logic
  final totalBalance = 0.0.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpense = 0.0.obs;
  final isBalanceHidden = false.obs;

  // Date Picker State
  final selectedDate = DateTime.now().obs;

  // Transaction List
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
    fetchTransactions(); // Fetch transactions for the selected date
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return;
      }

      final response = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false);

      final data = response as List;
      recentTransactions.value = data.map((item) {
        final type = (item['type'] ?? 'expense') == 'expense'
            ? TransactionType.expense
            : TransactionType.income;
        final category = item['category'] as String? ?? 'uncategorized';
        final iconData = _getIconForCategory(category);
        final color = _getColorForCategory(category);

        return Transaction(
          id: item['id']?.toString() ?? '',
          title: item['note'] as String? ?? 'No note',
          category: category,
          amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
          date: item['date'] != null
              ? DateTime.parse(item['date'])
              : DateTime.now(),
          type: type,
          iconData: iconData,
          color: color,
        );
      }).toList();

      _calculateBalance();
    } catch (e) {
      print("Error fetching transactions: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch transactions. Please check your Supabase Row Level Security policies.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateBalance() {
    double income = 0;
    double expense = 0;
    for (var tx in recentTransactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    monthlyIncome.value = income;
    monthlyExpense.value = expense;
    totalBalance.value = income - expense;
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case "Food":
        return Icons.restaurant;
      case "Transport":
        return Icons.directions_car;
      case "Shopping":
        return Icons.shopping_bag;
      case "Bills":
        return Icons.receipt;
      case "Fun":
        return Icons.sports_esports;
      case "Salary":
        return Icons.work;
      case "Freelance":
        return Icons.code;
      case "Gift":
        return Icons.card_giftcard;
      case "Invest":
        return Icons.trending_up;
      case "uncategorized":
        return Icons.help_outline;
      default:
        return Icons.attach_money;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case "Food":
        return Colors.orange;
      case "Transport":
        return Colors.blue;
      case "Shopping":
        return Colors.pink;
      case "Bills":
        return Colors.red;
      case "Fun":
        return Colors.purple;
      case "Salary":
        return Colors.green;
      case "Freelance":
        return Colors.indigo;
      case "Gift":
        return Colors.yellow;
      case "Invest":
        return Colors.teal;
      case "uncategorized":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}