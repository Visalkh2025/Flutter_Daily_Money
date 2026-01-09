import 'package:flutter/material.dart';

// ប្រភេទចំណូល ឬ ចំណាយ
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title; // Note or Title
  final String category;
  final double amount;
  final DateTime date;
  final TransactionType type;
  
  // UI Properties (មិនមានក្នុង Database តែបង្កើតចេញពី Category)
  final IconData iconData; 
  final Color color;

  Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    required this.iconData,
    required this.color,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // 1. ទាញយក Category មកសិន
    final category = json['category'] ?? 'Uncategorized';

    // 2. កំណត់ Type
    final type =
        json['type'] == 'expense' ? TransactionType.expense : TransactionType.income;

    // 🛠️ FIX: Handle null or empty string for the note.
    String finalTitle = 'No Note';
    final note = json['title'] ?? json['note'];
    if (note != null && (note is String && note.trim().isNotEmpty)) {
      finalTitle = note;
    }

    return Transaction(
      id: json['id'].toString(),
      title: finalTitle,
      category: category,
      amount: (json['amount'] as num).toDouble(), // ការពារ Error ទាំង int និង double
      date: DateTime.parse(json['date']), // បំប្លែង String ទៅ DateTime
      type: type,

      // 🔥 Logic បំប្លែង Category ទៅជា Icon និង Color
      iconData: _getIconForCategory(category),
      color: _getColorForCategory(category, type),
    );
  }

  // --- Helper Methods (Logic សម្រាប់ Icon & Color) ---

  static IconData _getIconForCategory(String category) {
    switch (category) {
      // Expense
      case 'Food': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_bag;
      case 'Bills': return Icons.receipt_long;
      case 'Fun': return Icons.movie_filter;
      // Income
      case 'Salary': return Icons.account_balance_wallet;
      case 'Freelance': return Icons.laptop_mac;
      case 'Gift': return Icons.card_giftcard;
      case 'Invest': return Icons.trending_up;
      // Default
      default: return Icons.category;
    }
  }

  static Color _getColorForCategory(String category, TransactionType type) {
    // បើជា Income ដាក់ពណ៌បៃតង
    if (type == TransactionType.income) {
      return const Color(0xFF4ADE80); // Green
    }
    
    // បើជា Expense ដាក់ពណ៌តាមប្រភេទ
    switch (category) {
      case 'Food': return Colors.orangeAccent;
      case 'Transport': return Colors.blueAccent;
      case 'Shopping': return Colors.purpleAccent;
      case 'Bills': return Colors.redAccent;
      case 'Fun': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }
}