import 'package:flutter/material.dart';
import 'package:get/get.dart';




class ExampleView extends StatefulWidget {
  ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  int count = 16;
  ExampleController exampleController = Get.put(ExampleController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Obx(()=> Text(
             exampleController.count.toString(),
              style: TextStyle(color: Colors.black, fontSize: 52),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        exampleController.increaseCount();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class ExampleController extends GetxController{

  RxInt count = 0.obs;
  increaseCount(){
    count ++;
  }

}




