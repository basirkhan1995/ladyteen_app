import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../Colors/colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormat;
  final bool secureText;
  final Widget? trailing;
  final double height;
  const InputField({super.key,
    this.onChanged,
    this.inputFormat,
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.secureText = false,
    this.trailing,
    this.height = 55
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height: height,
      width: MediaQuery.of(context).size.width *.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryColor.withOpacity(.09),

      ),

      child: Center(
        child: TextFormField(
          onChanged: onChanged,
          inputFormatters: inputFormat,
          obscureText: secureText,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
              hintText: Locales.string(context, hint),
              border: InputBorder.none,
              icon: Icon(icon),
              suffixIcon: trailing
          ),
        ),
      ),
    );
  }
}
