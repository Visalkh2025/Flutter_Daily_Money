import 'package:daily_money/Config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // ទាញយក User បច្ចុប្បន្ន
  final user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login Success! 🎉", style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text("User Email: ${user?.email ?? 'No Email'}"),
            SizedBox(height: 30),

            // ប៊ូតុង Logout
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Get.offAllNamed(Routes.signIn); // ត្រឡប់ទៅ Login វិញ
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
