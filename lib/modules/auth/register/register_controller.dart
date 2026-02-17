import 'package:democlass/modules/auth/register/register_repository.dart';
import 'package:democlass/service/api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  RegisterRepository registerRepository = RegisterRepository();

  register() async {
    Map body = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };
    final response = await registerRepository.register(body);
    if(response.status == ApiStatus.SUCCESS){
    }
  }
}
