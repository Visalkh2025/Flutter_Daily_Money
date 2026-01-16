import 'dart:io';
import 'package:daily_money/Controllers/home_controller.dart';
import 'package:daily_money/Controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController extends GetxController {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  final isLoading = false.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);
  final RxString currentAvatarUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUerProfile();
  }

  // 1. Pull current user info from Supabase to display
  void loadUerProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      namecontroller.text = user.userMetadata?['full_name'] ?? '';
      emailcontroller.text = user.email ?? '';
      currentAvatarUrl.value = user.userMetadata?['avatar_url'] ?? '';
    }
  }

  // 2. Pick Image from Gallery or Camera
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
   }
  }

Future<void> updateProfile() async {
  try {
    isLoading.value = true;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    String? newAvatarUrl;
    if (pickedImage.value != null) {
      final fileExt = pickedImage.value!.path.split('.').last;
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      await Supabase.instance.client.storage
          .from('avatars')
          .upload(filePath, pickedImage.value!);

      newAvatarUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(filePath);
    }

    // B. Update User Metadata
    final updateData = {
      'full_name': namecontroller.text.trim(),
    };
    if (newAvatarUrl != null) {
      updateData['avatar_url'] = newAvatarUrl;
    }

    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: updateData),
    );
    
    // 1. Update ProfileController (កូដចាស់របស់អ្នក)
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      profileController.userName.value = namecontroller.text.trim();
      if (newAvatarUrl != null) {
        profileController.userAvatarUrl.value = newAvatarUrl;
      }
    }
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.username.value = namecontroller.text.trim();
      if (newAvatarUrl != null) {
        homeController.profileImage.value = newAvatarUrl;
      }
    }

    Get.back();
    Get.snackbar("Success", "Profile updated successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
        
  } catch (e) {
    Get.snackbar("Error", "Failed to update profile",
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}

}
