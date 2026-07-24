import 'package:flutter/material.dart';
import '../screens/map_page.dart';

class MyMediaPage extends StatelessWidget {
  const MyMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: const [
          TabBar(
            tabs: [
              Tab(text: "Map"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                MapPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}