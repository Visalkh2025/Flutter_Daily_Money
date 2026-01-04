import 'package:daily_money/Models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// Import model របស់អ្នក

class HomeController extends GetxController {
  // User Info
  final username = "Khem Visal".obs;
  final profileImage = "https://i.pravatar.cc/150?img=12".obs;

  // Balance Logic
  final totalBalance = 1000.00.obs;
  final monthlyIncome = 200.00.obs;
  final monthlyExpense = 50.00.obs;
  final isBalanceHidden = false.obs;

  // 🔥 Date Picker State (សម្រាប់ EasyDateTimeLine)
  final selectedDate = DateTime.now().obs;

  void toggleBalanceHide() => isBalanceHidden.value = !isBalanceHidden.value;
  
  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    print("Selected Date: $date");
    // នៅពេលអនាគត៖ ហៅ Function ដើម្បី Filter Transaction តាមថ្ងៃនៅទីនេះ
  }

  // Mock Data
  final recentTransactions = <Transaction>[
    Transaction(
      id: 't1', title: 'Lunch at Cafe', category: 'Food',
      amount: 15.50, date: DateTime.now(), type: TransactionType.expense,
      iconData: Icons.restaurant, color: Colors.orange,
    ),
    Transaction(
      id: 't2', title: 'Freelance Project', category: 'Income',
      amount: 500.00, date: DateTime.now().subtract(Duration(days: 1)),
      type: TransactionType.income,
      iconData: Icons.work, color: Colors.green,
    ),
     Transaction(
      id: 't3', title: 'Uber Ride', category: 'Transport',
      amount: 8.50, date: DateTime.now().subtract(Duration(hours: 5)),
      type: TransactionType.expense,
      iconData: Icons.directions_car, color: Colors.blue,
    ),
  ].obs;
}