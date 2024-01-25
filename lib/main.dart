import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Colors/colors.dart';
import 'package:ladyteen_app/Provider/ui_provider.dart';
import 'package:ladyteen_app/Views/Authentication/login.dart';
import 'package:ladyteen_app/Views/Onboarding/onboarding.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'Components/Env/env.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  await Locales.init(['en', 'fa']);
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());

  doWhenWindowReady(() {
    const minSize = Size(1280, 720);
    appWindow.minSize = minSize;
    appWindow.show();
  });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..initialize(),
      child: Consumer<UiProvider>(
          builder: (context, UiProvider notifier,child) {
            return LocaleBuilder(
                builder: (locale) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Lady Teen',
                  localizationsDelegates: Locales.delegates,
                  supportedLocales: Locales.supportedLocales,
                  locale: locale,
                  theme: ThemeData(
                    tabBarTheme: TabBarTheme(
                      labelStyle: TextStyle(
                        fontFamily: locale.toString() == "en"?"Ubuntu":"Dubai",
                      )
                    ),
                      appBarTheme:  const AppBarTheme(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                      ),
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: locale.toString() == "en"?"Ubuntu":"Dubai",
                      primarySwatch: Env.buildMaterialColor(primaryColor)
                  ),
                  home: notifier.isOnboarding? const Onboarding() : const LoginScreen(),
                )

            );
          }
      ),
    );
  }
}
