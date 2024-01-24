import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Colors/colors.dart';
import 'package:ladyteen_app/Views/Settings/about.dart';
import 'package:ladyteen_app/Views/Settings/database_settings.dart';
import 'package:ladyteen_app/Views/Settings/general.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final tabPages = [
      const GeneralSettings(),
      const DatabaseSettings(),
      const About(),
    ];
    final tabs = <Widget>[
       const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Tab(
          child: Row(
            children: [
              Icon(Icons.settings_suggest_sharp),
              SizedBox(width: 8),
              LocaleText("general")
            ],
          ),
        ),
      ),

       const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Tab(
            child: Row(
              children: [
                Icon(Icons.backup),
                SizedBox(width: 8),
                LocaleText("database")
              ],
            ),
          )),

       const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Tab(
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 8),
              LocaleText("about")
            ],
          ),

        ),
      ),

    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 14,
          leading: const Icon(Icons.settings),
          title: const LocaleText("settings"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TabBar(
                    splashBorderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                    labelPadding: const EdgeInsets.only( left: 0, right: 0, top: 0),
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    unselectedLabelColor: Colors.black54,
                    automaticIndicatorColorAdjustment: true,
                    indicatorWeight: 4,
                    labelStyle: const TextStyle(fontSize: 16),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: primaryColor,
                    indicatorColor: primaryColor,
                    tabs: tabs),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: tabPages,
        ),
      ),
    );
  }
}
