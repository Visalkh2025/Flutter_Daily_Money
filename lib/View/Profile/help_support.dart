import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Help & Support", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("FAQ", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildFaqItem("How do I add a transaction?", "Click the orange '+' button at the bottom center of the screen."),
            _buildFaqItem("Can I export my data?", "Yes, go to Profile > Export Data to download CSV or PDF."),
            _buildFaqItem("Is my data safe?", "Yes, your data is secured with Supabase Row Level Security."),
            
            const SizedBox(height: 30),
            Text("Contact Us", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildContactTile(Icons.email, "Email Support", "support@dailymoney.com"),
            _buildContactTile(Icons.facebook, "Facebook Page", "Daily Money App"),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: GoogleFonts.poppins(color: Colors.grey[400])),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFF27121), child: Icon(icon, color: Colors.white)),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey)),
      ),
    );
  }
}