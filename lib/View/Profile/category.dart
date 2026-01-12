import 'package:daily_money/Models/default_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Category extends StatefulWidget {
  final String? defaultName;
  final IconData? defaultIcon;
  
  
  final bool? isExpense; 

  const Category({
    super.key, 
    this.defaultName, 
    this.defaultIcon,
    this.isExpense, 
  });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final nameController = TextEditingController();
  final isLoading = false.obs;

  
  String selectedType = 'expense'; 
  IconData selectedIcon = Icons.help_outline; 
  
  
  final Color defaultColor = Colors.white;

  bool isDefaultLocked = false;
  late final List<DefaultCategory> _defaultCategories;

  final List<IconData> icons = [
    Icons.fastfood, Icons.restaurant, Icons.local_cafe, Icons.local_bar,
    Icons.directions_car, Icons.directions_bus, Icons.flight,
    Icons.shopping_bag, Icons.receipt_long, Icons.credit_card,
    Icons.person, Icons.medical_services, Icons.fitness_center,
    Icons.home, Icons.wifi, Icons.lightbulb,
    Icons.school, Icons.work, Icons.laptop_mac,
    Icons.movie, Icons.music_note, Icons.pets,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.defaultName != null) nameController.text = widget.defaultName!;
    if (widget.defaultIcon != null) selectedIcon = widget.defaultIcon!;

    
    if (widget.isExpense != null) {
      selectedType = widget.isExpense! ? 'expense' : 'income';
    }

    _defaultCategories = [
      DefaultCategory(name: 'Food', icon: Icons.fastfood),
      DefaultCategory(name: 'Transport', icon: Icons.directions_car),
      DefaultCategory(name: 'Shopping', icon: Icons.shopping_bag),
      DefaultCategory(name: 'Bills', icon: Icons.receipt_long),
      DefaultCategory(name: 'Entertainment', icon: Icons.movie),
      DefaultCategory(name: 'Health', icon: Icons.medical_services),
      DefaultCategory(name: 'Work', icon: Icons.work),
      DefaultCategory(name: 'Home', icon: Icons.home),
    ];
  }

  Future<void> saveCategory() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Required", "Please enter category name");
      return;
    }

    
    if (selectedIcon == Icons.help_outline) {
       Get.snackbar(
       "Required", 
       "Please select an icon below",
       backgroundColor: Colors.orange, 
       colorText: Colors.white
     );
     return;
    }

    try {
      isLoading.value = true;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      await Supabase.instance.client.from('categories').insert({
        'user_id': user.id,
        'name': nameController.text.trim(),
        'type': selectedType,
        'icon_code': selectedIcon.codePoint,
        'color_value': defaultColor.value, 
      });

      Get.back(result: true);
      Get.snackbar("Success", "Category created successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text("New Category",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                _buildTypeButton('Expense', 'expense'),
                const SizedBox(width: 16),
                _buildTypeButton('Income', 'income'),
              ],
            ),
            const SizedBox(height: 30),

            
            Text("Category Name",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              readOnly: isDefaultLocked,
              style: GoogleFonts.poppins(
                  color: isDefaultLocked ? Colors.grey : Colors.white),
              decoration: InputDecoration(
                hintText: "E.g. Bubble Tea",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(selectedIcon, color: Colors.white),
                suffixIcon: isDefaultLocked
                    ? IconButton(
                        icon: const Icon(Icons.lock, color: Colors.orange),
                        onPressed: () => setState(() => isDefaultLocked = false),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            
            Text("Quick Select",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _defaultCategories.length,
                itemBuilder: (context, index) {
                  final category = _defaultCategories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        nameController.text = category.name;
                        selectedIcon = category.icon;
                        isDefaultLocked = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(category.icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(category.name,
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            
            Text("Pick Icon",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: icons.map((icon) => GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedIcon == icon
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: selectedIcon == icon
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Icon(icon,
                        color: selectedIcon == icon ? Colors.white : Colors.grey,
                        size: 30),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 40),

            
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF27121),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Create Category",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String title, String value) {
    bool isSelected = selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (value == 'expense' ? Colors.redAccent : Colors.green)
                : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(title,
              style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}