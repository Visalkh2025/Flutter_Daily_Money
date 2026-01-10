import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String selectedLanguage = "English";

  final List<Map<String, String>> languages = [
    {"name": "English", "flag": "🇺🇸"},
    {"name": "ខ្មែរ (Khmer)", "flag": "🇰🇭"},
    {"name": "中文 (Chinese)", "flag": "🇨🇳"},
    {"name": "Français (French)", "flag": "🇫🇷"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("Language", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: languages.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey, thickness: 0.2),
        itemBuilder: (context, index) {
          final lang = languages[index];
          final isSelected = lang['name'] == selectedLanguage;

          return ListTile(
            onTap: () {
              setState(() => selectedLanguage = lang['name']!);
              Get.back();
              Get.snackbar("Language", "Changed to ${lang['name']}", backgroundColor: Colors.green, colorText: Colors.white);
            },
            leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
            title: Text(lang['name']!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
            trailing: isSelected 
                ? const Icon(Icons.check_circle, color: Color(0xFFF27121)) 
                : null,
          );
        },
      ),
    );
  }
}