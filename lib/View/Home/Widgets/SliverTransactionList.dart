import 'package:daily_money/Controllers/home_controller.dart';
import 'package:daily_money/Models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SliverTransactionList extends StatelessWidget {
  const SliverTransactionList({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.recentTransactions.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Text(
              "No transactions yet.",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList.separated(
          itemCount: controller.recentTransactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tx = controller.recentTransactions[index];
            return Dismissible(
              key: ValueKey(tx.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                controller.deleteTransaction(tx.id);
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(tx.iconData, color: Colors.black, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.title,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          Text(tx.category,
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${tx.type == TransactionType.income ? '+' : '-'} \$${tx.amount.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: tx.type == TransactionType.income
                                ? const Color(0xFF16A34A)
                                : Colors.black,
                          ),
                        ),
                        Text(DateFormat('hh:mm a').format(tx.date),
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 11)),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
