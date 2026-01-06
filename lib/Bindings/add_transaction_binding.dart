import 'package:daily_money/Controllers/add_transactions_controller.dart';
import 'package:get/get.dart';

class AddTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTransactionsController>(() => AddTransactionsController());
  }
}
