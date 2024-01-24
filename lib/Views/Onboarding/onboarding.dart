import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ladyteen_app/Components/Methods/button.dart';
import 'package:ladyteen_app/Components/Methods/text_field.dart';
import 'package:ladyteen_app/Provider/ui_provider.dart';
import 'package:ladyteen_app/SQLite/database_helper.dart';
import 'package:ladyteen_app/Views/Authentication/login.dart';
import 'package:provider/provider.dart';


 class Onboarding extends StatefulWidget {
   const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
   final formKey = GlobalKey <FormState>();
   final name = TextEditingController();
   final nationalId = TextEditingController();
   final username = TextEditingController();
   final password = TextEditingController();
   final email = TextEditingController();
   final phone = TextEditingController();
   final cardName = TextEditingController();
   final cardNumber = TextEditingController();
   final jobTitle = TextEditingController();
   final confirmPass = TextEditingController();
   final db = DatabaseHelper();

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.grey.withOpacity(.9),
       body: Form(
         key: formKey,
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
           child: Center(
             child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               width: 650,
               height: MediaQuery.of(context).size.height *.9,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(8),
                 boxShadow: const [
                   BoxShadow(
                     color: Colors.grey,
                     blurRadius: 1,
                     spreadRadius: 0,
                   )
                 ]
               ),
               child: Center(
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       const SizedBox(height: 15),

                       const ListTile(
                         title: LocaleText("get_started",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                       ),
                       InputField(hint: "first_name", icon: Icons.person,controller: name,
                         validator: (value){
                           if(value.isEmpty){
                             return Locales.string(context, "first_name_required");
                           }
                           return null;
                         },
                       ),
                       Row(
                         children: [
                           Expanded(flex: 3, child: InputField(hint: "email", icon: Icons.email,controller: email)),
                           Expanded(flex: 2, child: InputField(hint: "national_id", icon: Icons.important_devices,controller: nationalId)),

                         ],
                       ),

                       Column(
                         children: [
                           Row(
                             children: [
                               Expanded(flex: 3, child: InputField(hint: "phone", icon: Icons.phone,controller: phone)),
                               Expanded(flex: 2, child: InputField(hint: "job_title", icon: Icons.work,controller: jobTitle)),
                             ],
                           ),

                           const ListTile(
                             title: LocaleText("bank_info",style: TextStyle(fontWeight: FontWeight.bold),),
                           ),

                           Row(
                             children: [
                               Expanded(flex: 3, child: InputField(hint: "card_number", icon: Icons.credit_card_rounded,controller: cardNumber),),
                               Expanded(flex: 2, child: InputField(hint: "card_name", icon: Icons.credit_card_rounded,controller: cardName),),

                             ],
                           ),

                         ],
                       ),

                       const ListTile(
                         title: LocaleText("create_user",style: TextStyle(fontWeight: FontWeight.bold),),
                       ),

                       InputField(hint: "username", icon: Icons.account_circle_rounded,controller: username,
                         validator: (value){
                           if(value.isEmpty){
                             return Locales.string(context, "username_required");
                           }
                           return null;
                         },
                       ),
                       InputField(hint: "password", icon: Icons.lock,controller: password,
                         validator: (value){
                           if(value.isEmpty){
                             return Locales.string(context, "password_required");
                           }
                           return null;
                         },
                       ),
                       InputField(hint: "confirm_password", icon: Icons.lock,controller: confirmPass,
                         validator: (value){
                           if(value.isEmpty){
                             return Locales.string(context, "confirm_password_required");
                           }else if(password.text != confirmPass.text){
                             return Locales.string(context, "passwords_not_matched");
                           }
                           return null;
                         },
                       ),


                       Padding(
                         padding: const EdgeInsets.only(bottom: 5),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Consumer<UiProvider>(
                               builder: (context,UiProvider notifier, child) {
                                 return XButton(
                                   label: "sign_up",
                                   onTap: ()async{
                                    if(formKey.currentState!.validate()){
                                      var result =  await db.addIndAccUser(
                                          name.text,
                                          nationalId.text,
                                          jobTitle.text,
                                          phone.text,
                                          email.text,
                                          cardNumber.text,
                                          cardName.text,
                                          username.text,
                                          password.text);
                                      if(result>0){
                                        if(!mounted)return;
                                        notifier.disableOnboarding();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                      }
                                    }
                                   },
                                 );
                               }
                             ),
                           ],
                         ),
                       )


                     ],
                   ),
                 ),
               ),
             ),
           ),
         ),
       ),
     );
   }


}
