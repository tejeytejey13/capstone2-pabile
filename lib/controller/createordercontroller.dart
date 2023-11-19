import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  static CreateOrderController get instance => Get.find();

  final addorderimg = TextEditingController();
  final addordername = TextEditingController();
  final addorderprice = TextEditingController();
  final addorderdescription = TextEditingController();

  @override
  void dispose() {
    addordername.dispose();
    addorderprice.dispose();
    addorderdescription.dispose();

    super.dispose();
  }
}
