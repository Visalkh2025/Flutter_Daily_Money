import 'package:daily_money/Config/routes/routes.dart';
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

  void setIscheck(bool? value) {
    getIscheck.value = value ?? false;
  }

  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  void togglePasswordView() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // 🛠️ FIX 1: Return String? and return null
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null; // ✅ Return null មានន័យថា Valid
  }

  // 🛠️ FIX 1: Return String? and return null
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null; // ✅ Return null មានន័យថា Valid
  }
  @override
  void onReady() {
    super.onReady();
    // 🔥 ហៅមុខងារឆែកមើល Session នៅពេល Controller នេះចាប់ផ្តើមដំណើរការ
    _checkUserSession();
  }

  void _checkUserSession() {
    // 1. សួរទៅ Supabase: "តើមាន User កំពុង Login ទេ?"
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      // ✅ បើមាន -> ទៅ Home Screen ភ្លាម (មិនបាច់ Login ទៀតទេ)
      // ប្រើ Future.delayed បន្តិច ដើម្បីកុំឱ្យកូដជាន់គ្នាលឿនពេក
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed(Routes.main); // ឬ Routes.home តាមឈ្មោះ Route របស់អ្នក
      });
    }
  }

  Future<void> signup() async {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }
    if (!getIscheck.value) {
      Get.snackbar(
        "Required",
        "Please agree to Terms & Conditions",
        backgroundColor: Colors.black26,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        // 🛠️ FIX 3: ត្រូវដាក់ឈ្មោះ Key ឱ្យដូចក្នុង SQL Trigger (display_name)
        data: {'display_name': usernameController.text.trim()}, 
      );
      
      if (response.user != null) {
        Get.snackbar("Success", "Welcome ${usernameController.text}!");
        Get.offAllNamed(Routes.main); // កុំភ្លេច Navigate ទៅ Home // កុំភ្លេច Navigate ទៅ Home
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign Up Failed",
        e.message,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (response.user != null) {
        Get.snackbar("Success", "Welcome back!");
        Get.offAllNamed(Routes.main); // កុំភ្លេច Navigate ទៅ Home // Navigate to home
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign In Failed",
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong during Google sign in",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await Supabase.instance.client.auth.signOut();
      emailController.clear();
      passwordController.clear();
      usernameController.clear();
      Get.offAllNamed(Routes.signIn);
    } on AuthException catch (e) {
      Get.snackbar("Sign Out Failed", e.message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong during sign out",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    // IMPORTANT: For production, this should be handled by a secure Supabase Edge Function
    // to avoid exposing service role keys on the client-side.
    // This is a simulation for UI/UX purposes.
    try {
      isLoading.value = true;
      // 1. Sign out the user
      await Supabase.instance.client.auth.signOut();

      // 2. Clear text controllers
      emailController.clear();
      passwordController.clear();
      usernameController.clear();

      // 3. Navigate to Sign In screen
      Get.offAllNamed(Routes.signIn);

      // 4. Show success message
      Get.snackbar(
        "Account Deleted",
        "Your account has been successfully deleted.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong during account deletion.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}