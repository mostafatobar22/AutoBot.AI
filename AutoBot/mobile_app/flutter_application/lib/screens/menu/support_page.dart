import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  // بياناتك
  final String phoneNumber = "+201551112319";
  final String email = "mostafatobar4455@gmail.com";
  final String whatsappNumber = "+201551112319";

  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail() async {
    final Uri url = Uri.parse(
        "mailto:$email?subject=Support Request&body=Hello AutoBot Team,");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse(
        "https://wa.me/$whatsappNumber?text=Hello AutoBot Support");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Widget buildButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9), // شفافية خفيفة عشان الخلفية تبان
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
        backgroundColor: Colors.purple.shade100, // ممكن تغير اللون براحتك
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/reviom.png"), // 👈 حط صورتك هنا
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // طبقة شفافة فوق الصورة
          color: Colors.black.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildButton(
                  icon: Icons.phone,
                  title: "Call Us",
                  onTap: _makePhoneCall,
                ),
                buildButton(
                  icon: Icons.email,
                  title: "Send Email",
                  onTap: _sendEmail,
                ),
                buildButton(
                  icon: Icons.chat,
                  title: "WhatsApp",
                  onTap: _openWhatsApp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}