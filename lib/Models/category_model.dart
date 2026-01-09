import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String type;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> json) {
   return CategoryModel(
    id: json['id'].toString(),
    name: json['name'] ?? 'Unnamed',
    type: json['type'] ?? 'expense',
    icon:  IconData(json['icon_code'], fontFamily: 'MaterialIcons'),
    color: Color(json['color_value']),
   );
  }
}