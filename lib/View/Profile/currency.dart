import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Currency extends StatefulWidget {
  const Currency({super.key});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  // ឧទាហរណ៍: ដាក់ USD ជា Default សិន
  String selectedCurrency = "USD"; 

  final List<Map<String, String>> currencies = [
    {"code": "USD", "name": "United States Dollar", "symbol": "\$"},
    {"code": "KHR", "name": "Cambodian Riel", "symbol": "៛"},
    {"code": "EUR", "name": "Euro", "symbol": "€"},
    {"code": "GBP", "name": "British Pound", "symbol": "£"},
    {"code": "JPY", "name": "Japanese Yen", "symbol": "¥"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Currency", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: currencies.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey, thickness: 0.2),
        itemBuilder: (context, index) {
          final currency = currencies[index];
          final isSelected = currency['code'] == selectedCurrency;

          return ListTile(
            onTap: () {
              setState(() {
                selectedCurrency = currency['code']!;
              });
              // នៅពេលអនាគត អាច Save ចូល LocalStorage ឬ SettingsController
              Get.back();
              Get.snackbar("Updated", "Currency changed to ${currency['code']}", backgroundColor: Colors.green, colorText: Colors.white);
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(currency['symbol']!, style: const TextStyle(color: Color(0xFFF27121), fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            title: Text(currency['code']!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(currency['name']!, style: GoogleFonts.poppins(color: Colors.grey)),
            trailing: isSelected 
                ? const Icon(Icons.check_circle, color: Color(0xFFF27121)) 
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          );
        },
      ),
    );
  }
}