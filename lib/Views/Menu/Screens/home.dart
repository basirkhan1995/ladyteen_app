import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LocaleText("dashboard"),
      ),
    );
  }
}
