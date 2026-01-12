import 'package:daily_money/Models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class StatisticsController extends GetxController {
  final isLoading = false.obs;
  final currentPeriod = "Week".obs;
  final periods = ["Week", "Month", "Year"];
  final isExpense = true.obs;

  final barChartData = <double>[].obs;
  final pieChartData = <String, double>{}.obs;
  final totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  void changePeriod(String period) {
    currentPeriod.value = period;
    fetchStatistics();
  }

  void toggleExpense(bool value) {
    isExpense.value = value;
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      DateTime from;
      DateTime to;

      switch (currentPeriod.value) {
        case "Week":
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          from = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
          to = from.add(const Duration(days: 7));
          break;
        case "Month":
          from = DateTime(now.year, now.month, 1);
          to = DateTime(now.year, now.month + 1, 1);
          break;
        case "Year":
          from = DateTime(now.year, 1, 1);
          to = DateTime(now.year + 1, 1, 1);
          break;
        default:
          return;
      }

      final response = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq('user_id', user.id)
          .eq('type', isExpense.value ? 'expense' : 'income')
          .gte('date', from.toIso8601String())
          .lt('date', to.toIso8601String())
          .order('date', ascending: true);

      final transactions = (response as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      _processChartData(transactions);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load statistics: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _processChartData(List<Transaction> transactions) {
    pieChartData.clear();
    barChartData.clear();
    totalAmount.value = 0.0;

    final newPieData = <String, double>{};
    for (var tx in transactions) {
      totalAmount.value += tx.amount;
      newPieData.update(
        tx.category,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    pieChartData.addAll(newPieData);

    final newBarData = <double>[];
    switch (currentPeriod.value) {
      case "Week":
        final dailyTotals = List.filled(7, 0.0);
        for (var tx in transactions) {
          dailyTotals[tx.date.weekday - 1] += tx.amount;
        }
        newBarData.addAll(dailyTotals);
        break;
      case "Month":
        final weeklyTotals = List.filled(4, 0.0);
        for (var tx in transactions) {
          final weekOfMonth = (tx.date.day / 7).ceil() - 1;
          if (weekOfMonth < 4) {
            weeklyTotals[weekOfMonth] += tx.amount;
          }
        }
        newBarData.addAll(weeklyTotals);
        break;
      case "Year":
        final monthlyTotals = List.filled(12, 0.0);
        for (var tx in transactions) {
          monthlyTotals[tx.date.month - 1] += tx.amount;
        }
        newBarData.addAll(monthlyTotals);
        break;
    }
    barChartData.assignAll(newBarData);
  }
}
