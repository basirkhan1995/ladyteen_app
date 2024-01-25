import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../Colors/colors.dart';

class ZField extends StatelessWidget {
  final String title;
  final String? hint;
  final bool isRequire;
  final IconData icon;
  final Widget? end;
  final double fontSize;
  final bool securePassword;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final TextInputType? keyboardInputType;
  final TextEditingController? controller;
  final Widget? trailing;
  final List<TextInputFormatter>? inputFormat;
  const ZField(
      {Key? key,
        required this.title,
        this.hint,
        this.securePassword = false,
        this.end,
        this.isRequire = false,
        required this.icon,
        this.inputFormat,
        this.validator,
        this.fontSize = 15,
        this.controller,
        this.onChanged,
        this.trailing,
        this.keyboardInputType,
        this.inputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *.89,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        LocaleText(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: fontSize),
                        ),
                        isRequire? Text(" *",style: TextStyle(color: Colors.red.shade900),): const SizedBox(),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: MediaQuery.of(context).size.width *.9,
              child: Row(
                children: [
                  Flexible(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validator,
                        onChanged: onChanged,
                        obscureText: securePassword,
                        inputFormatters: inputFormat,
                        keyboardType: keyboardInputType,
                        controller: controller,
                        decoration: InputDecoration(
                          //contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                            helperStyle: TextStyle(fontSize: width/26),
                            // suffixIconConstraints: const BoxConstraints(maxWidth: 14),
                            suffixIcon: trailing,
                            suffix: end,
                            isDense: true,
                            enabledBorder: const UnderlineInputBorder(

                                borderSide: BorderSide(color: Colors.grey,width: 1.5)
                            ),

                            focusedBorder: const UnderlineInputBorder(

                                borderSide: BorderSide(color: primaryColor,width: 2)),

                            focusedErrorBorder: UnderlineInputBorder(

                              borderSide: BorderSide(color: Colors.red.shade900,width: 2),
                            ),

                            errorBorder: UnderlineInputBorder(
                              //borderRadius: BorderRadius.circular(widget.radius!),
                              borderSide: BorderSide(color: Colors.red.shade900),
                            ),
                            prefixIcon: Icon(icon,size: 20,color: primaryColor),
                            //hintText: Locales.string(context, title),
                            hintStyle: TextStyle(fontSize: fontSize)
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
