import 'package:daily_money/Controllers/auth_controller.dart';
import 'package:daily_money/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final homeController = Get.find<HomeController>();
  final authController = Get.find<AuthController>();
  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Privacy & Security", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildActionTile("Change Password", Icons.lock_outline, () {
              // TODO: Implement Change Password
            }),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                activeColor: const Color(0xFFF27121),
                secondary: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.fingerprint, color: Color(0xFFF27121)),
                ),
                title: Text("Biometric ID", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
                value: isBiometricEnabled,
                onChanged: (val) => setState(() => isBiometricEnabled = val),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showClearDataDialog,
              icon: const Icon(Icons.delete_forever, color: Colors.orange),
              label: Text("Clear All Transactions",
                  style: GoogleFonts.poppins(
                      color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _showDeleteAccountDialog,
              icon: const Icon(Icons.person_remove, color: Colors.redAccent),
              label: Text("Delete Account",
                  style: GoogleFonts.poppins(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFF27121)),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      ),
    );
  }

  void _showClearDataDialog() {
    Get.defaultDialog(
      title: "Clear All Data?",
      titleStyle:
          GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
      middleText:
          "This will permanently delete all your income and expense records.\nThis cannot be undone!",
      middleTextStyle:
          GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      backgroundColor: Colors.white,
      radius: 20,
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      onCancel: () {},
      confirm: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            Get.back();
            homeController.clearAllTransactions();
          },
          child: Text("Clear",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.defaultDialog(
      title: "Delete Account?",
      titleStyle:
          GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
      middleText:
          "Are you sure you want to delete your account? All your data will be permanently lost.",
      middleTextStyle:
          GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      backgroundColor: Colors.white,
      radius: 20,
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      onCancel: () {},
      confirm: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            Get.back();
            authController.deleteAccount();
          },
          child: Text("Delete",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}