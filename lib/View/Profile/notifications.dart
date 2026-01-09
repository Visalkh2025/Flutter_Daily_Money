import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isDailyReminder = true;
  bool isBudgetAlert = true;
  bool isTips = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Notifications", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSwitchTile(
              "Daily Reminder", 
              "Remind you to record transactions at 8 PM", 
              isDailyReminder, 
              (val) => setState(() => isDailyReminder = val)
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              "Budget Alert", 
              "Notify when you exceed 80% of budget", 
              isBudgetAlert, 
              (val) => setState(() => isBudgetAlert = val)
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              "Tips & Tricks", 
              "Receive financial tips every week", 
              isTips, 
              (val) => setState(() => isTips = val)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        activeColor: const Color(0xFFF27121),
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}