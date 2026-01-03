import 'package:daily_money/Bindings/auth_controller.dart';
import 'package:daily_money/Config/routes/routes.dart';
import 'package:daily_money/View/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

   SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: controller.signInFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // --- Logo Section ---
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // ដាក់រូប Logo របស់អ្នកនៅទីនេះ
                    borderRadius: BorderRadius.circular(15),
                    //image: const DecorationImage(image: AssetImage('assets/icons/google.png')),
                  ),
                  child: const Icon(Icons.circle_outlined, size: 40, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                Text(
                  "Welcome back",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter your details.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  label: "Email",
                  hint: "Enter your email",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                
                // Password Input
                Obx(() => CustomTextField(
                  label: "Password",
                  hint: "••••••••",
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  validator: controller.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value 
                        ? Icons.visibility_off_outlined 
                        : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: controller.togglePasswordView,
                  ),
                )),

                const SizedBox(height: 16),

                // --- Remember Me & Forgot Password ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox Row
                    Row(
                      children: [
                            Obx(() => SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: controller.isRememberMe.value,
                                onChanged: (value) => controller.toggleRememberMe(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                activeColor: Colors.black,
                              ),
                            )),
                            const SizedBox(width: 8),
                            Text(
                              "Remember me",
                               style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black87,
                              ),
                            ),
                      ],
                    ),
                    
                    // Forgot Password
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot password",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                              // --- Sign In Button ---
                              Obx(() => SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value 
                                      ? null 
                                      : () {
                                          controller.signIn();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30), 
                                    ),
                                    elevation: 0,
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                          "Sign in",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              )),                
                const SizedBox(height: 16),

                // --- Google Sign In Button ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.signIn();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Icon (ប្រើ Icon ឬ Image Asset)
                        //const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue), // ដាក់រូប Google Logo ផ្ទាល់ខ្លួនប្រសើរជាង
                        Image(image: const AssetImage('assets/icons/google1.png'), width: 30, height: 30),
                        const SizedBox(width: 10),
                        Text(
                          "Sign in with Google",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // --- Footer ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed(Routes.signUp);
                        // ទៅកាន់ទំព័រ Sign Up
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              
            ]),
          ),
        ),
      ),
    ));
  }


}
