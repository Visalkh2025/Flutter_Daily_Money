import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:daily_money/Controllers/edit_profile_controller.dart'; 

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      resizeToAvoidBottomInset: true, 
      
      appBar: AppBar(
        title: Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), 
          padding: const EdgeInsets.all(24),
          
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      ImageProvider? imageProvider;
                      if (controller.pickedImage.value != null) {
                        imageProvider = FileImage(controller.pickedImage.value!);
                      } else if (controller.currentAvatarUrl.value.isNotEmpty) {
                        imageProvider = NetworkImage(controller.currentAvatarUrl.value);
                      }

                      return GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF27121), width: 2),
                            image: imageProvider != null 
                                ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                                : null,
                          ),
                          child: imageProvider == null 
                              ? const Icon(Icons.person, size: 60, color: Colors.grey) 
                              : null,
                        ),
                      );
                    }),
                    
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector( 
                        onTap: controller.pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF27121),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              
              _buildLabel("Full Name"),
              const SizedBox(height: 10),
              TextField(
                controller: controller.namecontroller,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: _buildInputDecoration(Icons.person),
              ),
              const SizedBox(height: 20),
              
              _buildLabel("Email"),
              const SizedBox(height: 10),
              TextField(
                controller: controller.emailcontroller,
                readOnly: true, 
                style: GoogleFonts.poppins(color: Colors.grey),
                decoration: _buildInputDecoration(Icons.email),
              ),
              
              const SizedBox(height: 40),

              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF27121),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: controller.isLoading.value 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Save Changes", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                )),
              ),
              
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF2C2C2E),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(16), 
        borderSide: const BorderSide(color: Color(0xFFF27121))
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
    );
  }
}
