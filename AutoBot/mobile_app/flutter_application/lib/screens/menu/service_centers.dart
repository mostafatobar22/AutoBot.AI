import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCentersPage extends StatelessWidget {
  const ServiceCentersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Centers"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ServiceCenterCard(
            name: "Ezz Elarab",
            phone: "0235390610",
            lat: 30.0594549,
            lng: 31.033468,
          ),

          ServiceCenterCard(
            name: "Mansour Auto",
            phone: "0238380292",
            lat: 30.0163037,
            lng: 31.1012722,
          ),

          ServiceCenterCard(
            name: "Abou Ghaly Motors",
            phone: "0235390610",
            lat: 30.0594549,
            lng: 31.033468,
          ),

          ServiceCenterCard(
            name: "Ghabbour Auto",
            phone: "0235390610",
            lat: 30.0594549,
            lng: 31.033468,
          ),

        ],
      ),
    );
  }
}

class ServiceCenterCard extends StatefulWidget {
  final String name;
  final String phone;
  final double lat;
  final double lng;

  const ServiceCenterCard({
    super.key,
    required this.name,
    required this.phone,
    required this.lat,
    required this.lng,
  });

  @override
  State<ServiceCenterCard> createState() => _ServiceCenterCardState();
}

class _ServiceCenterCardState extends State<ServiceCenterCard> {
  Future<void> _call() async {
    final Uri url = Uri.parse("tel:${widget.phone}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMap() async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.car_repair, size: 30),
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Call"),
            onTap: _call,
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Open Location"),
            onTap: _openMap,
          ),
        ],
      ),
    );
  }
}