import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text(
              "AutoBot.AI",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "About Us:\n"

              "AutoBot.AI is an intelligent automotive assistant designed to help you understand your vehicle in a simple and practical way. By connecting directly to your car through an OBD-II interface, AutoBot translates complex vehicle data into clear insights you can actually use.\n"
              "\n"
              "Our goal is to make vehicle diagnostics accessible to everyone — not just engineers or technicians. Whether you want to check your fuel level, understand a warning light, or get quick guidance about a potential issue, AutoBot gives you straightforward answers in real time.\n"
                  "\n"
              "We combine automotive engineering knowledge with AI to deliver a smarter driving experience, helping you stay informed, confident, and in control of your vehicle.\n"
                  "\n"
              "Copyright:\n"
              "© 2026 AutoBot.AI. All rights reserved.\n"
                  "\n"
              "Disclaimer:\n"
              "AutoBot provides preliminary insights and guidance based on available vehicle data. It is not a substitute for professional inspection or authorized service centers.\n"
              ,
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}