import 'package:flutter/material.dart';
import 'pages/playground_page.dart';
import 'pages/items_page.dart';

void main() => runApp(const TweightApp());

class TweightApp extends StatefulWidget {
  const TweightApp({super.key});
  @override
  State<TweightApp> createState() => _TweightAppState();
}

class _TweightAppState extends State<TweightApp> {
  int _idx = 0;

  final _pages = const [
    PlaygroundPage(),
    ItemsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tweight (Local Prototype)',
      home: Scaffold(
        body: _pages[_idx],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _idx,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.science_outlined), label: 'Playground'),
            NavigationDestination(icon: Icon(Icons.list_alt), label: 'Items'),
          ],
          onDestinationSelected: (i) => setState(() => _idx = i),
        ),
      ),
    );
  }
}
