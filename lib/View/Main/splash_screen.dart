import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_money/Controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    authController.checkUserSession(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF9F9F7).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5, 
                  )
                ],
                image: const DecorationImage( 
                  image: AssetImage('assets/icons/លុយថ្មី.png'),
                  fit: BoxFit.cover,
                  )
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "LUY លុយ",
              style: GoogleFonts.poppins(
                fontSize: 25, 
                fontWeight: FontWeight.w500, 
                color: Colors.black.withAlpha(500)
              ),
            ),
            const SizedBox(height: 100),

            // 3. Loading Indicator តូចមួយ
            const CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}