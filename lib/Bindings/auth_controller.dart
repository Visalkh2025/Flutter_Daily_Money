import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  String validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return '';
  }

  String validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return '';
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!getIscheck.value) {
      Get.snackbar(
        "Required",
        "Please agree to Terms & Conditions",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    //   //call supabase logic
    //   print('Sign Up: ${emailController.text}');
    //   await Future.delayed(Duration(seconds: 2));
    //   isLoading.value = false;
    // } finally {
    //   isLoading.value = false;
    // }

    try {
      isLoading.value = true;
      //superbase logic here
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {'full_name': usernameController.text},
      );
      if (response.user != null) {
        Get.snackbar("Success", "Welcome ${usernameController.text}!");
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign Up Failed",
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
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();  
}
}