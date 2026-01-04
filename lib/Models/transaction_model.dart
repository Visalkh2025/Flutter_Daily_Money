import 'package:flutter/material.dart';

// ប្រភេទចំណូល ឬ ចំណាយ
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final TransactionType type;
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
}