
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowUsPage extends StatelessWidget {
  const FollowUsPage({super.key});

  // TODO: حط لينكاتك الحقيقية هنا
  static const String linkedinUrl = "https://www.linkedin.com/company/reviom-tech/";

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("مش قادر أفتح اللينك: $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow us"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      "assets/riviom_logo.png",
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "RIVIOM",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Catch Your Infinity 🏎",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Social icons row (corporate cards)
            Row(
              children: [
              
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialCard(
                    label: "LinkedIn",
                    icon: Icons.business,
                    onTap: () => _openLink(context, linkedinUrl),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Optional small footer text
            Text(
              "© ${DateTime.now().year} REVIOM. All rights reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 30),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}