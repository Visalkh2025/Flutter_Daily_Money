import 'package:daily_money/Models/category_model.dart';
import 'package:daily_money/Models/default_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_money/Controllers/home_controller.dart';

class AddTransactionsController extends GetxController {
  // 1. Variables
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final selectDate = DateTime.now().obs;

  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final isExpense = true.obs;
  final isLoading = false.obs;
  final RxList<CategoryModel> categories = RxList<CategoryModel>();

  // 🔥 បន្ថែមថ្មី: សម្រាប់បិទបើក Edit Mode (ដើម្បីលុប Category)
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // 🔥 Function បិទបើក Edit Mode
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }

  Future<void> fetchCategories() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final List<Map<String, dynamic>> data = await Supabase.instance.client
          .from('categories')
          .select()
          .eq('user_id', user.id);

      if (data.isNotEmpty) {
        // ប្រើ fromMap ឬ fromJson របស់អ្នក
        categories.value = data.map((e) => CategoryModel.fromMap(e)).toList();
        filterCategories();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  void filterCategories() {
    final filtered = categories
        .where((c) => c.type == (isExpense.value ? 'expense' : 'income'))
        .toList();
    
    // Reset selection if the selected one is gone or not in current list
    if (selectedCategory.value != null && !filtered.contains(selectedCategory.value)) {
      selectedCategory.value = null;
    }

    // Optional: Auto select first one
    if (filtered.isNotEmpty && selectedCategory.value == null) {
      selectedCategory.value = filtered.first;
    }
  }

  void toggleType(bool value) {
    isExpense.value = value;
    filterCategories();
  }

  // 3. Save Function
  Future<void> saveTransaction() async {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter amount", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar("Error", "Please select a category", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final double amount = double.parse(amountController.text);

      // 🔥 Logic: "No Note" (ប្រសិនបើទុកចោលទទេ)
      String noteText = noteController.text.trim().isEmpty 
          ? 'No Note' 
          : noteController.text.trim();

      await Supabase.instance.client.from('transactions').insert({
        'user_id': user.id,
        'amount': amount,
        'title': noteText, // 👈 ប្រើ noteText ដែលបាន check
        'category': selectedCategory.value!.name,
        'date': selectDate.value.toIso8601String(),
        'type': isExpense.value ? 'expense' : 'income',
        'icon_code': selectedCategory.value!.icon.codePoint,
        'color_value': selectedCategory.value!.color.value,
      });

      Get.back();
      Get.snackbar("Success", "Transaction added", backgroundColor: Colors.green, colorText: Colors.white);

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchTransactions();
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 Delete Category with Safety Check
  Future<void> deleteCategory(int categoryId, String categoryName) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // 1. Check if used in transactions
      final inUseResponse = await Supabase.instance.client
          .from('transactions')
          .select('id')
          .eq('user_id', user.id)
          .eq('category', categoryName)
          .limit(1);

      if (inUseResponse.isNotEmpty) {
        Get.defaultDialog(
          title: "Cannot Delete",
          titleStyle: const TextStyle(fontWeight: FontWeight.bold),
          middleText: "'$categoryName' is used in existing transactions.\nPlease delete those transactions first.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          buttonColor: Colors.orange,
          onConfirm: () => Get.back(),
        );
        return;
      }

      // 2. Delete if safe
      await Supabase.instance.client
          .from('categories')
          .delete()
          .eq('id', categoryId);

      // 3. Update UI
      categories.removeWhere((cat) => cat.id == categoryId);
      if (selectedCategory.value?.id == categoryId) {
        selectedCategory.value = null;
      }

      // Re-filter to update the visible list
      filterCategories(); 

      Get.snackbar(
        "Deleted",
        "Category '$categoryName' removed",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}