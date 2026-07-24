import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  Widget buildProduct({
    required String title,
    required String description,
    required String price,
    required String imagePath,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ صورة المنتج
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏷️ اسم المنتج
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // 📝 الوصف
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),

                const SizedBox(height: 12),

                // 💲 السعر
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildProduct(
            title: "Vertex Standard",
            imagePath: "assets/vertex_standard.png", // 👈 حط الصورة هنا
            price: "\$30",
            description:
                "A plug & play Bluetooth device designed for direct connection with your vehicle. "
                "Works only when your phone is inside the car, providing real-time diagnostics and vehicle data. "
                "No GPS or remote tracking support.",
          ),

          buildProduct(
            title: "Vertex Pro",
            imagePath: "assets/vertex_pro.png", // 👈 حط الصورة هنا
            price: "\$50",
            description:
                "Advanced version with built-in GSM & GPS. "
                "Access your vehicle from anywhere, track its live location, and monitor its status remotely. "
                "Ideal for full control and smart vehicle management.",
          ),
        ],
      ),
    );
  }
}