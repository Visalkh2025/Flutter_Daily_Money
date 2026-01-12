import 'package:daily_money/Controllers/profile_controller.dart';
import 'package:daily_money/View/Profile/Widgets/section_title.dart';
import 'package:daily_money/View/Profile/currency.dart';
import 'package:daily_money/View/Profile/edit_profile.dart';
import 'package:daily_money/View/Profile/export_data.dart';
import 'package:daily_money/View/Profile/help_support.dart';
import 'package:daily_money/View/Profile/language.dart';
import 'package:daily_money/View/Profile/notifications.dart';
import 'package:daily_money/View/Profile/privacy_security_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: _appbar,
      body: Column(
        children: [_header, _logoutbutton],
      ),
    );
  }
  get _appbar => AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      );
  get _header => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                //
                color: Colors.black87,
                borderRadius: BorderRadius.circular(24),
                // boxShadow: [
                //   BoxShadow(color: const Color(0xFFF27121).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                // ],
              ),
              child: Row(
                children: [
                  Obx(() {
                    String avatarUrl = controller.userAvatarUrl.value;
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        // 🔥 បើមានរូប -> បង្ហាញរូប
                        image: avatarUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: avatarUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 40)
                          : null,
                    );
                  }),
                  const SizedBox(width: 20),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.userEmail.value,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit Icon
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => Get.to(() => const EditProfile()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Menu Options
            SectionTitle(title: "General"),
            Obx(
              () => _buildProfileOption(
                icon: Icons.currency_exchange,
                title: "Currency",
                value: controller.currency.value,
                onTap: () => Get.to(() => const Currency()),
              ),
            ),
            Obx(
              () => _buildProfileOption(
                icon: Icons.notifications,
                title: "Notifications",
                value: controller.notificationsEnabled.value ? "On" : "Off",
                onTap: () => Get.to(() => const Notifications()),
              ),
            ),
            Obx(
              () => _buildProfileOption(
                icon: Icons.language,
                title: "Language",
                value: controller.language.value,
                onTap: () => Get.to(() => const Language()),
              ),
            ),

            const SizedBox(height: 15),
            SectionTitle(title: "Account"),
            _buildProfileOption(
              icon: Icons.file_download,
              title: "Export Data",
              onTap: () => Get.to(() => const ExportData()),
            ),
            _buildProfileOption(
              icon: Icons.lock,
              title: "Privacy & Security",
              onTap: () => Get.to(() => const PrivacySecurityScreen()),
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () => Get.to(() => const HelpSupport()),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
  get _logoutbutton => // 3. Log Out Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                  elevation: 0,
                ),
                child: Text(
                  "Log Out",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );

  // --- Helper Widgets ---

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(
                value,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
