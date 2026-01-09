import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:get/get.dart';

class StatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticsController>(() => StatisticsController());
  }
}
