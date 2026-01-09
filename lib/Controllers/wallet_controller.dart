import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  // Variable សម្រាប់ដឹងថាគេកំពុងមើលកាតទីប៉ុន្មាន
  final currentCardIndex = 0.obs;

  // Mock Data: ទិន្នន័យកាតធនាគារ ឬកាបូបលុយ
  final myCards = [
    {
      "name": "Main Wallet",
      "balance": "850.00",
      "number": "**** **** **** 1234",
      "exp": "12/28",
      "type": "VISA",
      "colors": [const Color(0xFFE94057), const Color(0xFFF27121)], // Orange Gradient
    },
    {
      "name": "ABA Bank",
      "balance": "3,400.50",
      "number": "**** **** **** 5678",
      "exp": "09/26",
      "type": "MasterCard",
      "colors": [const Color(0xFF003057), const Color(0xFF0091D2)], // Blue Gradient
    },
    {
      "name": "ACLEDA Bank",
      "balance": "120.00",
      "number": "**** **** **** 9999",
      "exp": "01/30",
      "type": "UnionPay",
      "colors": [const Color(0xFF011f4b), const Color(0xFF005b96)], // Green Gradient
    },
  ];

  void updateCardIndex(int index) {
    currentCardIndex.value = index;
  }
}