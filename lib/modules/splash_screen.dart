import 'package:democlass/main.dart';
import 'package:democlass/modules/auth/login/login_view.dart';
import 'package:democlass/modules/hotels/hotel_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    if (token == null) {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } else {
      // User already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HotelView()),
      );
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
