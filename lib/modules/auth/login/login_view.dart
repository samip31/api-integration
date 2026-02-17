import 'package:democlass/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
   LoginView({super.key});
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login",),
      backgroundColor: Colors.blue,),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
        children: [
          Text("Email"),
         TextField(
           controller: loginController.emailController,
         ),
          SizedBox(
            height: 40,
          ),
          Text("Password"),
          TextField(
            controller: loginController.passwordController,
          ),
          SizedBox(height: 40,),
          GestureDetector(
            onTap: () async {
              await loginController.login(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),

              child: Center(
                child: Text(
                  "Log In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
            ),
      )),);
  }
}
