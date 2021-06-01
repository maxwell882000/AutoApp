import 'package:get/get.dart';
class SingletonGetX {
  final  _nameOfCards = "".obs;


  static final SingletonGetX _instance = SingletonGetX._internal();
  factory SingletonGetX() {
    return _instance;
  }
  RxString get nameOfCards => _nameOfCards;


  void setLinks(String links){
    _nameOfCards.value = links;
  }

  SingletonGetX._internal();
}