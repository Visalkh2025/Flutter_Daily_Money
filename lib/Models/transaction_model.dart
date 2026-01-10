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
    final type = json['type'] == 'expense' ? TransactionType.expense : TransactionType.income;
    final category = json['category'] ?? 'Uncategorized';

    return Transaction(
      id: json['id'].toString(),
      title: json['title'] ?? '', // Default to empty string if null
      category: category,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      type: type,
      iconData: json['icon_code'] != null 
                ? IconData(json['icon_code'], fontFamily: 'MaterialIcons') 
                : _getIconForCategory(category), // Fallback
      color: json['color_value'] != null 
             ? Color(json['color_value']) 
             : _getColorForCategory(category, type), // Fallback
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
      case 'Entertainment': return Icons.movie_filter;
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
      case 'Entertainment': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }
}