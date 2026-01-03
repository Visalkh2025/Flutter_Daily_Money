import 'package:daily_money/Bindings/auth_binding.dart';
import 'package:daily_money/Config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      initialRoute: Routes.signUp,
      getPages: Routes.pages,
    );
  }
}