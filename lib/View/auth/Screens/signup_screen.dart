import 'package:daily_money/Controllers/auth_controller.dart';
import 'package:daily_money/Config/routes/routes.dart';
import 'package:daily_money/View/auth/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // បិទ Keyboard ពេលចុចកន្លែងផ្សេង
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            // 🔥 សំខាន់ណាស់: ត្រូវ Wrap ជាមួយ Form និងដាក់ Key
            child: Form(
              key: controller.signUpFormKey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // --- Logo Section ---
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.circle_outlined, size: 40, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Welcome",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "I hope you enjoy our app.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 1. Username Field
                  CustomTextField(
                    label: "User Name",
                    hint: "Enter your Name",
                    controller: controller.usernameController,
                    // Note: Username មិនសូវត្រូវការ Validator តឹងរឹងទេ តែបើចង់ដាក់ក៏បាន
                    validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                  ),
                  const SizedBox(height: 16),

                  // 2. Email Field
                  CustomTextField(
                    label: "Email",
                    hint: "Enter your email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    // 🔥 ដាក់ Validator នៅទីនេះ
                    validator: controller.validateEmail, 
                  ),
                  const SizedBox(height: 16),

                  // 3. Password Field
                  Obx(() => CustomTextField(
                    label: "Password",
                    hint: "",
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    // 🔥 ដាក់ Validator នៅទីនេះ
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

                  // --- Terms & Conditions Checkbox ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() => SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              // 🔥 ប្រើ getIscheck ជំនួស isRememberMe (ព្រោះនេះជា Terms)
                              value: controller.getIscheck.value, 
                              onChanged: controller.setIscheck,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              activeColor: Colors.black,
                            ),
                          )),
                          const SizedBox(width: 8),
                          Text(
                            "I agree to the processing of Personal Data",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Sign Up Button ---
                  Obx(() => SizedBox( // Wrap Obx ដើម្បីបង្ហាញ Loading
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value 
                          ? null // បើ Loading -> Disable Button
                          : () {
                              // 🔥 ហៅ function signup ពី Controller
                              controller.signup();
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
                              "Sign Up",
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
                        // Future: Add Google Sign In Logic
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
                           Image(image: const AssetImage('assets/icons/google1.png'), width: 30, height: 30),
                          //const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue), // Placeholder icon
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
                        "Already have an account? ",
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // ប្រើ Get.offNamed ជំនួស offAllNamed បើចង់ឱ្យចុច Back បាន
                          // តែ offAllNamed ក៏ល្អសម្រាប់ Clear Stack
                          Get.offAllNamed(Routes.signIn); 
                        },
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // បន្ថែម Space ខាងក្រោម
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}