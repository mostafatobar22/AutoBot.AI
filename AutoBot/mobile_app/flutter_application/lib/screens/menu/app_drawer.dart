import 'package:flutter/material.dart';

import 'about_page.dart';
import 'settings_page.dart';
import 'follow_us_page.dart';
import 'support_page.dart';
import 'how_to_use_page.dart';
import 'service_centers.dart';
import 'shop_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.pop(context); // close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [

            const ListTile(
              title: Text(
                "AutoBot.AI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Vehicle diagnostics AI assistant"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text("Shop"),
              onTap: () => _open(context, const ShopPage()),
            ),
                        ListTile(
              leading: const Icon(Icons.car_repair_outlined),
              title: const Text("Service Centers"),
              onTap: () => _open(context, const ServiceCentersPage()),
            ),
                        ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text("Support"),
              onTap: () => _open(context, const SupportPage()),
            ),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () => _open(context, const SettingsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text("Follow us"),
              onTap: () => _open(context, const FollowUsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              onTap: () => _open(context, const AboutPage()),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("How to use"),
              onTap: () => _open(context, const HowToUsePage()),
            ),

            
          ],
        ),
      ),
    );
  }
}