
 import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/Authentication/login.dart';

class UiProvider extends ChangeNotifier{
 bool _isChecked = false;
 bool get isChecked => _isChecked;

 bool _isOnboarding = true;
 bool get isOnboarding => _isOnboarding;

 bool _isLogin = false;
 bool get isLogin => _isLogin;

 bool _isLoading = false;
 bool get isLoading => _isLoading;

 late SharedPreferences storage;

 disableOnboarding()async{
  _isOnboarding = false;
  _isOnboarding = await storage.setBool("isOnboarding", _isOnboarding);
  notifyListeners();
 }

  loading(){
   _isLoading = true;
   notifyListeners();
  }

 offLoading(){
  _isLoading = false;
  notifyListeners();
 }

 setLogin()async{
  _isLogin = true;
  _isLogin = await storage.setBool("isLogin", _isLogin);
  notifyListeners();
 }


 void toggleCheck()async{
  _isChecked = !_isChecked;
  notifyListeners();
 }

 logout(context){
  _isLogin = false;
  storage.setBool("isLogin", _isLogin);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));
  notifyListeners();
 }


 initialize()async{
  storage = await SharedPreferences.getInstance();
  _isLogin = storage.getBool("isLogin")??false;
  _isOnboarding = storage.getBool("isOnboarding")??false;
  notifyListeners();
 }
}