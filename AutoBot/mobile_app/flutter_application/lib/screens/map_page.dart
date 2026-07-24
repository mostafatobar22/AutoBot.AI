import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {

    // 👇 حط هنا لوكيشن العربية
    final LatLng carLocation = LatLng(30.0444, 31.2357); // Cairo example

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.black,
          child: const Text(
            "Vehicle Location",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),

        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: carLocation,
              initialZoom: 13,
            ),
            children: [
              // 🗺️ الخريطة
              TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

              userAgentPackageName: 'developer.android.com/training/package-visibility', // 👈 مهم جداً

              additionalOptions: {
                'User-Agent': 'AutoBot.AI App (contact: your@email.com)',
              },
            ),

              // 📍 الماركر
              MarkerLayer(
                markers: [
                  Marker(
                    point: carLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}