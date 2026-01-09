import 'package:daily_money/Controllers/home_controller.dart';
import 'package:daily_money/Controllers/statistics_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<StatisticsController>(StatisticsController());
    // Add other controllers that MainScreen and its tabs might need
  }
}
