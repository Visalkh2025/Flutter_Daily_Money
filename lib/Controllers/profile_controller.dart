import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:daily_money/Config/routes/routes.dart'; // Import Routes របស់អ្នក

class ProfileController extends GetxController {
  final userEmail = ''.obs;
  final userName = ''.obs;
  final currency = 'USD (\$)'.obs;
  final language = 'English'.obs;
  final notificationsEnabled = true.obs;
  final categories = <String>['Food', 'Transport', 'Shopping'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? "No Email";
      // ព្យាយាមយកឈ្មោះពី User Metadata (បើមាន) ឬដាក់ឈ្មោះលេងៗសិន
      userName.value = user.userMetadata?['full_name'] ?? "Khem Visal";
    }
  }

  void addCategory(String categoryName) {
    categories.add(categoryName);
  }

  void deleteCategory(String categoryName) {
    categories.remove(categoryName);
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(Routes.signIn); // ត្រឡប់ទៅ Login វិញ
  }
}