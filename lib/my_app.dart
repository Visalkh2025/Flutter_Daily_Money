import 'package:daily_money/Config/routes/routes.dart';
import 'package:daily_money/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 ជំហានសំខាន់: ដាក់ Controller ឱ្យដំណើរការនៅទីនេះ
    // ដើម្បីឱ្យវាឆែក Session (onReady) ភ្លាមៗពេល App បើក
    Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      // ទុក Sign In ជាផ្លូវដំបូងដដែល 
      // (បើមាន User, AuthController នឹងរុញទៅ Home ដោយស្វ័យប្រវត្តិ)
      initialRoute: Routes.signIn, 
      
      getPages: Routes.pages,
    );
  }
}