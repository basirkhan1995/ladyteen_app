import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../Colors/colors.dart';
import 'drop_down.dart';

class SwitchLanguage extends StatefulWidget {
  final double width;
  const SwitchLanguage({super.key, this.width = 160});

  @override
  State<SwitchLanguage> createState() => _SwitchLanguageState();
}

class _SwitchLanguageState extends State<SwitchLanguage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: widget.width,
            height: 40,
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(5)),
            child: CustomDropDown(
              defaultSelectedIndex: 1,
              borderWidth: 0,
              items: const [
                CustomDropdownMenuItem(
                  value: "en",
                  child: Text("English"),
                ),
                CustomDropdownMenuItem(
                  value: "fa",
                  child: Text("فارسی"),
                ),
              ],
              hintText: Locales.currentLocale(context).toString(),
              borderRadius: 5,
              onChanged: (val) {
                setState(() {
                  Locales.change(context, val);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
