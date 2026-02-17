import 'package:democlass/modules/auth/register/register_repository.dart';
import 'package:democlass/service/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RegisterRepository registerRepository = RegisterRepository();
  login() async {
    Map body = {

      "email": emailController.text,
      "password": passwordController.text,
    };
    final response = await registerRepository.register(body);
    if(response.status == ApiStatus.SUCCESS){
    }
  }
}
