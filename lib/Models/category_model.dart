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

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? 'Unnamed',
      type: json['type'] ?? 'expense',
      icon: IconData(json['icon_code'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['color_value'] as int),
    );
  }
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel.fromJson(map);
  }
}
