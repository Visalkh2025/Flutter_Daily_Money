import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int touchedIndex = -1;
  final controller = Get.find<StatisticsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Statistics", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildToggle(),
              const SizedBox(height: 20),
              _buildTimeFilter(),
              const SizedBox(height: 30),
              Text(
                controller.isExpense.value ? "Spending by Category" : "Income by Category",
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: _showingPieSections(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                        Text(
                          NumberFormat.currency(symbol: "\$").format(controller.totalAmount.value),
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildIndicators(),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Activity Trend", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: _getMaxY(),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _getBottomTitles(value),
                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _getBarGroups(),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildToggleButton("Expense", true),
          _buildToggleButton("Income", false),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleExpense(value),
        child: Obx(() {
          final isSelected = controller.isExpense.value == value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (value ? Colors.redAccent : Colors.greenAccent)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: controller.periods.map((period) {
        return GestureDetector(
          onTap: () => controller.changePeriod(period),
          child: Obx(() {
            bool isSelected = controller.currentPeriod.value == period;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                period,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }

  Widget _buildIndicators() {
    final colors = [Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.red, Colors.amber, Colors.teal, Colors.indigo];
    final categories = controller.pieChartData.keys.toList();
    if (categories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(categories.length, (index) {
        return _Indicator(
          color: colors[index % colors.length],
          text: categories[index],
        );
      }),
    );
  }

  double _getMaxY() {
    if (controller.barChartData.isEmpty) return 1;
    final maxVal = controller.barChartData.reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2; // Add 20% padding
  }

  String _getBottomTitles(double value) {
    switch (controller.currentPeriod.value) {
      case "Week":
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        if (value.toInt() >= 0 && value.toInt() < days.length) return days[value.toInt()];
        break;
      case "Month":
        const weeks = ['W1', 'W2', 'W3', 'W4'];
         if (value.toInt() >= 0 && value.toInt() < weeks.length) return weeks[value.toInt()];
        break;
      case "Year":
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        if (value.toInt() >= 0 && value.toInt() < months.length) return months[value.toInt()];
        break;
    }
    return '';
  }

  List<BarChartGroupData> _getBarGroups() {
    final data = controller.barChartData;
    if (data.isEmpty) return [];

    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: controller.isExpense.value ? Colors.orange : Colors.greenAccent,
            width: controller.currentPeriod.value == "Year" ? 12 : 22,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _showingPieSections() {
    final pieData = controller.pieChartData;
    if (pieData.isEmpty) return [];
    
    final colors = [Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.red, Colors.amber, Colors.teal, Colors.indigo];
    final categories = pieData.keys.toList();
    final total = controller.totalAmount.value;

    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final category = categories[i];
      final value = pieData[category]!;
      final percentage = (value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: '$percentage%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  const _Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
