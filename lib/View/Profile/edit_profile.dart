import 'package:daily_money/Controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final isLoading = false.obs;
  
  // ហៅ ProfileController មកដើម្បី Update ឈ្មោះភ្លាមៗពេល Save
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // ដាក់ឈ្មោះចាស់ចូលក្នុងប្រអប់ស្រាប់
    nameController.text = profileController.userName.value;
  }

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) return;

    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      
      // Update User Metadata ក្នុង Supabase
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'full_name': nameController.text.trim()}),
      );

      // Update ក្នុង App ភ្លាមៗ
      profileController.userName.value = nameController.text.trim();

      Get.back();
      Get.snackbar("Success", "Profile updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF27121), width: 2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 60),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF27121),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            Text("Full Name", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),
            
            Text("Email", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              readOnly: true, // Email មិនអាចកែបានទេ
              controller: TextEditingController(text: profileController.userEmail.value),
              style: GoogleFonts.poppins(color: Colors.grey),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
              ),
            ),

            const Spacer(),

            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27121),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Save Changes", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}