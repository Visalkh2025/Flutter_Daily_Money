import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Privacy & Security", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildActionTile("Change Password", Icons.lock_outline, () {}),
            
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
              child: SwitchListTile(
                activeColor: const Color(0xFFF27121),
                secondary: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.fingerprint, color: Color(0xFFF27121)),
                ),
                title: Text("Biometric ID", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
                value: isBiometricEnabled,
                onChanged: (val) => setState(() => isBiometricEnabled = val),
              ),
            ),

            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text("Delete Account", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFFF27121)),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      ),
    );
  }
}