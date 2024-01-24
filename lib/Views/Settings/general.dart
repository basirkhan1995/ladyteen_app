import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            TextButton(onPressed: ()=>Locales.change(context, "en"), child: const Text("English")),
            TextButton(onPressed: ()=>Locales.change(context, "fa"), child: const Text("فارسی")),

          ],
        ),
      )
    );
  }
}
