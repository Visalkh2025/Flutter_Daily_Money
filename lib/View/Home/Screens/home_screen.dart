import 'package:daily_money/Controllers/home_controller.dart';
import 'package:daily_money/Models/transaction_model.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.find<HomeController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildBalanceCard(),
                  const SizedBox(height: 25),
                  _buildTimeline(),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("See All",
                              style: GoogleFonts.poppins(color: Colors.grey)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _buildSliverTransactionList();
            }),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverTransactionList() {
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

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) => controller.onDateSelected(selectedDate),
        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.switcher,
          dateFormatter: DateFormatter.fullDateDMY(),
        ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          height: 56,
          width: 56,
          borderColor: Colors.transparent,
          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            dayNumStyle: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            dayStrStyle:
                GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            dayNumStyle: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            dayStrStyle:
                GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(() => CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        NetworkImage(controller.profileImage.value),
                  )),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good Morning!",
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[600])),
                  Obx(() => Text(
                        controller.username.value,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // Total Balance Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Balance", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14)),
              Obx(() => GestureDetector(
                onTap: () => controller.toggleBalanceHide(),
                child: Icon(
                  controller.isBalanceHidden.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                  size: 20,
                ),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.isBalanceHidden.value
                ? "••••••••"
                : NumberFormat.currency(symbol: "\$", decimalDigits: 2).format(controller.totalBalance.value),
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          )),
          const SizedBox(height: 24),
          
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseBox(
                  title: "Income",
                  amount: controller.monthlyIncome.value,
                  icon: Icons.arrow_upward,
                  color: const Color(0xFF4ADE80),
                  bgColor: const Color(0xFF4ADE80).withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIncomeExpenseBox(
                  title: "Expense",
                  amount: controller.monthlyExpense.value,
                  icon: Icons.arrow_downward,
                  color: const Color(0xFFF87171),
                  bgColor: const Color(0xFFF87171).withOpacity(0.2),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseBox({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      color: Colors.grey[400], fontSize: 11)),
              Obx(() => Text(
                    controller.isBalanceHidden.value
                        ? "••••"
                        : NumberFormat.currency(symbol: "\$", decimalDigits: 2)
                            .format(amount),
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
