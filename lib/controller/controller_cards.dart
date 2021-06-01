import 'package:get/get.dart';

class ControllerCards extends GetxController {
  String  _nameOfCards = "";
  static ControllerCards get to => Get.find();
  void setName(String name) {
    _nameOfCards = name;
    update(); // use update() to update counter variable on UI when increment be called
  }
  String get nameOfCards  => _nameOfCards;
}