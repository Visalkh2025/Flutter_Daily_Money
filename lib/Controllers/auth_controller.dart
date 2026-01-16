import 'dart:async';
import 'package:daily_money/Config/routes/routes.dart';
import 'package:daily_money/View/auth/Screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  var isRememberMe = false.obs;
  var isPasswordHidden = true.obs;
  var getIscheck = false.obs; 
  var isLoading = false.obs;
  
  // Variables OTP
  var isVerifying = false.obs;
  var resendTimer = 60.obs;
  Timer? _timer;

  // Lifecycle Methods
  @override
  void onReady() {
    super.onReady();
    checkUserSession();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // --- Toggles & Helper Methods (រក្សាទុកទាំងអស់) ---
  void setIscheck(bool? value) => getIscheck.value = value ?? false;
  void toggleRememberMe() => isRememberMe.value = !isRememberMe.value;
  void togglePasswordView() => isPasswordHidden.value = !isPasswordHidden.value;

  // --- Validators ---
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
  // 🔥 1. OTP LOGIC 
  void startResendTimer() {
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        _timer?.cancel();
      }
    });
  }
  Future<void> verifyOtp(String otpCode) async {
    if (otpCode.length < 6) return; 

    try {
      isVerifying.value = true;

      final response = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.signup,
        token: otpCode,
        email: emailController.text.trim(),
      );

      if (response.user != null) {
        Get.offAllNamed(Routes.main);
        Get.snackbar("Success", "Welcome to Daily Money!");
      }
    } on AuthException {
      Get.snackbar("Invalid Code", "The code is wrong or expired.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Verification failed.", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isVerifying.value = false;
    }
  }
  // Function resend OTP
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: emailController.text.trim(),
      );
      startResendTimer();
      Get.snackbar("Sent", "New code sent to your email.");
    } catch (e) {
      Get.snackbar("Error", "Could not resend code.");
    }
  }
  // 2. SIGN UP (OTP Screen)

  Future<void> signup() async {
    if (getIscheck.value == false) {
      Get.snackbar(
        "Required", 
        "Please accept the Terms & Conditions to continue.", 
        backgroundColor: Colors.redAccent, 
        colorText: Colors.white
      );
      return; 
    }

    // 2. Validate Form (Email/Password)
    if (!signUpFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {'full_name': usernameController.text.trim()},
      );

      if (response.user != null) {
        Get.to(() => const OtpScreen()); 
        Get.snackbar("Verification", "Code sent! Please check your email.");
      }

    } on AuthException catch (e) {
      Get.snackbar("Sign Up Failed", e.message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // 3. SIGN IN 
  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.user != null) {
        Get.offAllNamed(Routes.main);
        Get.snackbar("Success", "Welcome back!", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } on AuthException catch (e) {
      if (e.message.contains("Email not confirmed")) {
        Get.to(() => const OtpScreen());
        Get.snackbar("Activation Required", "Please verify your email first.", backgroundColor: Colors.orange, colorText: Colors.white);
        resendOtp(); 
      } else {
        Get.snackbar("Login Failed", e.message, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // 4. GOOGLE SIGN IN (រក្សាទុកដដែល)
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    } catch (e) {
      Get.snackbar("Error", "Google Sign In Failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // 5. SIGN OUT (រក្សាទុកដដែល)
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.auth.signOut();

      emailController.clear();
      passwordController.clear();
      usernameController.clear();

      Get.offAllNamed(Routes.signIn);
    } catch (e) {
      Get.snackbar("Error", "Logout failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // 6. DELETE ACCOUNT (រក្សាទុកដដែល)
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.auth.signOut();

      emailController.clear();
      passwordController.clear();
      usernameController.clear();

      Get.offAllNamed(Routes.signIn);
      Get.snackbar("Deleted", "Account removed locally.", backgroundColor: Colors.grey, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Deletion failed", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // 7. CHECK SESSION 
  // void _checkUserSession() {
  //   final session = Supabase.instance.client.auth.currentSession;
  //   if (session != null) {
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       Get.offAllNamed(Routes.main);
  //     });
  //   }
  // }

void checkUserSession() async {
  await Future.delayed(const Duration(seconds: 2));

  final session = Supabase.instance.client.auth.currentSession;
  
  if (session != null) {
    Get.offAllNamed(Routes.main); 
  } else {
    Get.offAllNamed(Routes.signIn);
  }
}
}