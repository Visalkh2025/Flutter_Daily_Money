import 'package:daily_money/Controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Wallets", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () {
              Get.snackbar("Coming Soon", "Add Card feature will be available soon!", colorText: Colors.black, backgroundColor: Colors.grey[200]);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Balance", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                Text("\$4,370.50", style: GoogleFonts.poppins(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: 30),

          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              onPageChanged: controller.updateCardIndex,
              itemCount: controller.myCards.length,
              itemBuilder: (context, index) {
                final card = controller.myCards[index];
                return _buildCreditCard(card);
              },
            ),
          ),

          const SizedBox(height: 20),

          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.myCards.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: controller.currentCardIndex.value == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: controller.currentCardIndex.value == index ? Colors.black : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Quick Actions", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.send, "Transfer"),
                _buildActionButton(Icons.payments, "Pay Bill"),
                _buildActionButton(Icons.history, "History"),
                _buildActionButton(Icons.more_horiz, "More"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> card) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: card['colors'],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight ,
        ),
        boxShadow: [
          BoxShadow(
            color: (card['colors'][0] as Color).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card['name'],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.contactless, color: Colors.white70, size: 28),
            ],
          ),
          
          Row(
            children: [
              const Icon(Icons.sim_card, color: Colors.white70, size: 40),
              const SizedBox(width: 10),
              Text(
                card['number'],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, letterSpacing: 2),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Balance", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text("\$${card['balance']}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Exp", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  Text(card['exp'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
