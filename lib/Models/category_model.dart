import 'package:flutter/material.dart';

class CategoryModel {
  final int id; // Supabase ID is int/bigint
  final String name;
  final String type; // 'income' or 'expense'
  final IconData icon; // The Icon itself
  final Color color; // The Color

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  // 🔥 កន្លែងសំខាន់គឺនៅត្រង់នេះ!
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? 'Unnamed',
      type: json['type'] ?? 'expense',

      // 1. បំប្លែងលេខកូដ (int) មកជា IconData វិញ
      // ត្រូវប្រាកដថាដាក់ fontFamily: 'MaterialIcons'
      icon: IconData(json['icon_code'] as int, fontFamily: 'MaterialIcons'),

      // 2. បំប្លែងលេខកូដ (int) មកជា Color វិញ
      color: Color(json['color_value'] as int),
    );
  }

  // ប្រើ forMap ជំនួស fromJson ក៏បាន (តាមទម្លាប់របស់អ្នក)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel.fromJson(map);
  }
}
