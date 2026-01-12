import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:daily_money/View/Statistic/Widgets/indicator_widget.dart';
import 'package:daily_money/View/Statistic/Widgets/time_filter.dart';
import 'package:daily_money/View/Statistic/Widgets/toggle_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text("Statistics", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black)),
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
              _buildToggle(context),
              const SizedBox(height: 20),
              TimeFilter(controller: controller, context: context),
              const SizedBox(height: 30),
              Text(
                controller.isExpense.value ? "Spending by Category" : "Income by Category",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
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
                        sections: _showingPieSections(context),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Total", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                        Text(
                          NumberFormat.currency(symbol: "\$").format(controller.totalAmount.value),
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IndicatorsWidget(controller: controller, context: context),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Activity Trend", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black)),
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
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
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

  Widget _buildToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ToggleButton(controller: controller, context: context, title: "Expense", value: true),
          ToggleButton(controller: controller, context: context, title: "Income", value: false),
        ],
      ),
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

  List<PieChartSectionData> _showingPieSections(BuildContext context) {
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
        titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}
