import 'package:democlass/modules/auth/login/login_repository.dart';
import 'package:democlass/modules/auth/register/register_repository.dart';
import 'package:democlass/modules/splash_screen.dart';
import 'package:democlass/service/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginRepository loginRepository = LoginRepository();

  login(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    final response = await loginRepository.login(body);
    if(response.status == ApiStatus.SUCCESS){
      await prefs.setString('userToken', response.response?.result?.token??"");


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
  }
}
