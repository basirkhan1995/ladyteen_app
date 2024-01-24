import 'package:flutter/material.dart';
import 'package:ladyteen_app/Views/Menu/Screens/accounts.dart';
import 'package:ladyteen_app/Views/Menu/Screens/home.dart';
import 'package:ladyteen_app/Views/Menu/Screens/settings.dart';
import 'package:ladyteen_app/Views/Menu/Screens/transactions.dart';

class MenuDetails{
  final String title;
  final IconData icon;
  final Widget page;

  MenuDetails({
    required this.title,
    required this.icon,
    required this.page,
  });
}

 class MenuItems{
  List<MenuDetails> items = [
    MenuDetails(title: "dashboard", icon: Icons.bar_chart_rounded,page: const HomeScreen()),
    MenuDetails(title: "accounts", icon: Icons.account_circle_rounded,page: const Accounts()),
    MenuDetails(title: "activities", icon: Icons.ssid_chart_rounded,page: const Transactions()),
    MenuDetails(title: "settings", icon: Icons.settings,page: const Settings()),
  ];
 }