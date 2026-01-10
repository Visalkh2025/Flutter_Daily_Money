// នៅក្នុង privacy_security_screen.dart

// 1. Import Home Controller
import 'package:daily_money/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RemoveData extends StatefulWidget {
  const RemoveData({super.key});

  @override
  State<RemoveData> createState() => _RemoveDataState();
}

class _RemoveDataState extends State<RemoveData> {
  
  // ...
  
  // ហៅ Controller មកប្រើ
  final homeController = Get.find<HomeController>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... AppBar ...
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ... មុខងារចាស់ៗ (Change Password, Biometric) ...

            const Spacer(),
            
            // 🔥 ប៊ូតុង Clear Data
            TextButton.icon(
              onPressed: _showClearDataDialog, // ហៅផ្ទាំងសួរ
              icon: const Icon(Icons.delete_forever, color: Colors.orange),
              label: Text("Clear All Transactions", style: GoogleFonts.poppins(color: Colors.orange, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 10),

            // ប៊ូតុង Delete Account (ចាស់របស់អ្នក)
            TextButton(
              onPressed: () {},
              child: Text("Delete Account", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔥 ផ្ទាំងសួរបញ្ជាក់ (Confirmation Dialog)
  void _showClearDataDialog() {
    Get.defaultDialog(
      title: "Clear All Data?",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
      middleText: "This will permanently delete all your income and expense records.\nThis cannot be undone!",
      middleTextStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      backgroundColor: Colors.white,
      radius: 20,
      
      // ប៊ូតុង Cancel
      textCancel: "Cancel",
      cancelTextColor: Colors.black,
      onCancel: () {}, // បិទ Dialog
      
      // ប៊ូតុង Confirm (Clear)
      confirm: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            Get.back(); // បិទ Dialog សិន
            homeController.clearAllTransactions(); // ហៅមុខងារលុប
          },
          child: Text("Clear", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}