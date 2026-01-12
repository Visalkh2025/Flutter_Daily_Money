import 'package:daily_money/Config/routes/routes.dart';
import 'package:daily_money/Config/themes/app_theme.dart';
import 'package:daily_money/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // to check user session on app start( on ready immedately)
    Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: Routes.splash,
      getPages: Routes.pages,
    );
  }
}
