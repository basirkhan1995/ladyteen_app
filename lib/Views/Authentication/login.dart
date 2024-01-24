import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Json/user.dart';
import 'package:ladyteen_app/Provider/ui_provider.dart';
import 'package:ladyteen_app/SQLite/database_helper.dart';
import 'package:ladyteen_app/Views/Menu/menu.dart';
import 'package:provider/provider.dart';
import '../../Components/Methods/button.dart';
import '../../Components/Methods/text_field.dart';
import 'background.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;
  bool isChecked = false;
  bool isValidated = false;
  bool accessDenied = false;

  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  authenticate()async{
    var res = await db.authenticate(Users(usrName: username.text, usrPassword: password.text));
    if(res == true){
      if(!mounted)return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Start()));
    }else{
    setState(() {
      accessDenied = true;
    });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ListTile(
                title: LocaleText(
                  "welcome",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                subtitle: LocaleText("login_message"),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Input Fields
                        InputField(
                          controller: username,
                          validator: (value) {
                            if (value.isEmpty) {
                              return Locales.string(context, "username_required");
                            }
                            return null;
                          },
                          hint: "username",
                          icon: Icons.account_circle,
                        ),

                        InputField(
                            controller: password,
                            validator: (value) {
                              if (value.isEmpty) {
                                return Locales.string(context, "password_required");
                              }
                              return null;
                            },
                            hint: "password",
                            icon: Icons.lock,
                            secureText: !isVisible,
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),

                        //Login Button
                        Consumer<UiProvider>(
                            builder: (context, UiProvider notifier, child) {
                              return XButton(
                                width: .8,
                                label: "login",
                                onTap: () async{
                                  if(formKey.currentState!.validate()){
                                    authenticate();

                                    setState(() {
                                      isValidated = false;
                                    });
                                    }else{
                                    setState(() {
                                      isValidated = true;
                                    });
                                  }
                                },
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Trailing
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isValidated? LocaleText(
                    "validation_message",
                    style: TextStyle(color: Colors.red.shade900),
                  ): const SizedBox(),
                  accessDenied? LocaleText(
                    "auth_message",
                    style: TextStyle(color: Colors.red.shade900),
                  ): const SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
