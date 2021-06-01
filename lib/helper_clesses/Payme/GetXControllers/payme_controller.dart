import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/CustomDialog.dart';
import 'package:flutter_projects/helper_clesses/Payme/payme.dart';
import 'package:get/get.dart';

import '../code_verification.dart';

class PaymeController extends GetxController {
  String _numberCard = "";
  String _date = "";
  String _code = "";
  bool _loading = false;

  Payme _payme;
  void setNumberCard(String numberCard) {
    this._numberCard = numberCard;
    update();
  }
  void setCode(String code) {
    this._code = code;
    update();
  }
  static PaymeController get to => Get.find();
  String get numberCard => _numberCard;

  String get code => _code;
  String get date => _date;

  bool get loading => _loading;

  void setLoading(bool loading){
    this._loading = loading;
    update();
  }

  void setPayme(Payme payme){
    _payme = payme;
  }
  void setDate(String date) {
    String changed = date.replaceAll("/", "");
    this._date = changed;
    update();
  }
  String validateNumber(text){
    RegExp regExp = new RegExp(r"^[0-9]{16}$");
    return regExp.hasMatch(text) ? null: "Пожалуйста введите правильный номер карты".tr;
  }
  String validateDate(text){
    RegExp regExp = new RegExp(r"^[0-9]{2}/[0-9]{2}$");
    return regExp.hasMatch(text)? null: "Формат: 01/21".tr;
  }
  String validateCode(String text) {
    return text.isNotEmpty?null:"Пожалуйтса заполните поле".tr;
  }

  void formSubmit(GlobalKey<FormState> _formState , String amountId ) async{
    setLoading(true);

      if(_formState.currentState.validate()){
        _formState.currentState.save();
        print(date);
        print(numberCard);
        setPayme(new Payme(
          number: numberCard,
          expire: date,
          userId: SingletonUserInformation().userId.toString(),
          amountId: amountId
        ));
        try {
          final result = await _payme.cardsCreate();
          if (!result) {
            await _payme.getVerifyCode();
            CustomDialog.dialog(
              barrierDismissible: false,
              context: Get.context,
              width: Get.width,
              child: CodeVerification(),
              alignment: Alignment.center,
            );
          }
        }
        catch(e){
          CustomDialog.show(text: e, title: "Ошибка".tr);
        }
      }
      setLoading(false);
  }
  Future resendCode() async {
    setLoading(true);
    try {
      await _payme.getVerifyCode();
      CustomDialog.show(
          text: "Код подтверждения успешно отправлен!".tr,
          title: "Отправлен".tr
      );
    }
    catch(e){
      CustomDialog.show(text: e , title: "Ошибка".tr);
    }
    setLoading(false);
  }
  void sendCode(GlobalKey<FormState> _formState) async{
    setLoading(true);
    if(_formState.currentState.validate()){
      _formState.currentState.save();
      try {
        final result = await _payme.cardsVerify(code);
      }
      catch(e){
        CustomDialog.show(text: e , title: "Ошибка".tr);
      }
    }
    setLoading(false);
  }
}
