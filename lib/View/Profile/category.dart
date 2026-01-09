import 'package:daily_money/Models/default_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AddCategoryScreen extends StatefulWidget {
  final String? defaultName;
  final IconData? defaultIcon;

  const AddCategoryScreen({super.key, this.defaultName, this.defaultIcon});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final nameController = TextEditingController();
  final isLoading = false.obs;

  // State for selected options
  String selectedType = 'expense';
  IconData selectedIcon = Icons.category;
  Color selectedColor = Colors.orange;

  // Define a simple class for default categories
  late final List<DefaultCategory> _defaultCategories;

  @override
  void initState() {
    super.initState();
    if (widget.defaultName != null) {
      nameController.text = widget.defaultName!;
    }
    if (widget.defaultIcon != null) {
      selectedIcon = widget.defaultIcon!;
    }

    _defaultCategories = [
      DefaultCategory(name: 'Food', icon: Icons.fastfood),
      DefaultCategory(name: 'Transport', icon: Icons.directions_car),
      DefaultCategory(name: 'Shopping', icon: Icons.shopping_bag),
      DefaultCategory(name: 'Bills', icon: Icons.receipt_long),
      DefaultCategory(name: 'Entertainment', icon: Icons.movie),
      DefaultCategory(name: 'Health', icon: Icons.medical_services),
      DefaultCategory(name: 'Education', icon: Icons.school),
      DefaultCategory(name: 'Work', icon: Icons.work),
      DefaultCategory(name: 'Home', icon: Icons.home),
      DefaultCategory(name: 'Travel', icon: Icons.flight),
      DefaultCategory(name: 'Gifts', icon: Icons.card_giftcard),
    ];
  }

  // List of available icons
  final List<IconData> icons = [
    // Food & Drink
    Icons.fastfood, Icons.restaurant, Icons.local_cafe, Icons.local_bar,
    Icons.cake, Icons.local_pizza, Icons.bakery_dining, Icons.icecream,

    // Transport
    Icons.directions_car, Icons.directions_bus, Icons.directions_bike,
    Icons.flight, Icons.local_gas_station, Icons.train, Icons.local_taxi,

    // Shopping & Bills
    Icons.shopping_bag, Icons.shopping_cart, Icons.receipt_long,
    Icons.credit_card, Icons.account_balance, Icons.attach_money,

    // Personal & Health
    Icons.person, Icons.medical_services, Icons.fitness_center,
    Icons.spa, Icons.chair, Icons.content_cut,

    // Home & Utilities
    Icons.home, Icons.wifi, Icons.lightbulb, Icons.water_drop,
    Icons.phone_android, Icons.tv, Icons.bed,

    // Education & Work
    Icons.school, Icons.work, Icons.laptop_mac, Icons.book,
    Icons.edit, Icons.camera_alt,

    // Entertainment & Others
    Icons.sports_esports, Icons.movie, Icons.music_note,
    Icons.pets, Icons.card_giftcard, Icons.celebration, Icons.park,
  ];

  // List of available colors
  final List<Color> colors = [
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.red,
    Colors.purple,
    Colors.green,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
    Colors.cyan,
  ];

  Future<void> saveCategory() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Required", "Please enter category name");
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
        'color_value': selectedColor.value,
      });

      Get.back(result: true);
      Get.snackbar(
        "Success",
        "Category created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to add category");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: Text(
          "New Category",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type Selector (Expense / Income)
            Row(
              children: [
                _buildTypeButton('Expense', 'expense'),
                const SizedBox(width: 16),
                _buildTypeButton('Income', 'income'),
              ],
            ),
            const SizedBox(height: 30),

            // Name Input
            Text(
              "Category Name",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: "E.g. Bubble Tea",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  selectedIcon,
                  color: selectedColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Default Category Suggestions
            Text(
              "Or choose a default",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
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
                          Text(
                            category.name,
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Color Picker
            Text(
              "Pick Color",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),

            // Icon Picker
            Text(
              "Pick Icon",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: icons
                    .map(
                      (icon) => GestureDetector(
                        onTap: () => setState(() => selectedIcon = icon),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedIcon == icon
                                ? selectedColor.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: selectedIcon == icon
                                ? Border.all(color: selectedColor, width: 2)
                                : null,
                          ),
                          child: Icon(
                            icon,
                            color: selectedIcon == icon
                                ? selectedColor
                                : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 40),

            // Save Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF27121),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Create Category",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
            border: isSelected ? null : Border.all(color: Colors.grey[800]!),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
