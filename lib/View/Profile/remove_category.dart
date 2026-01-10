import 'package:daily_money/Controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RemoveCategory extends StatelessWidget {
  RemoveCategory({super.key});

  final controller = Get.find<ProfileController>();

    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Manage Categories",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    _showDeleteConfirmation(context, category);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Category", style: GoogleFonts.poppins()),
          content: Text(
            "Are you sure you want to delete the category '$category'?",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: GoogleFonts.poppins()),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Delete", // Fix: Removed extra positional arguments
                style: GoogleFonts.poppins(color: Colors.redAccent),
              ),
              onPressed: () {
                controller.deleteCategory(category);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}