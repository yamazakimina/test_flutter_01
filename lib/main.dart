import 'package:flutter/material.dart';
// import 'homepage.dart';
import 'partners_find.dart';
// import 'partners_find.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Users",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const PartnersFind(),
    );
  }
}
