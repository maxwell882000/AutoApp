import 'package:get/get.dart';

class Errors {
  static Map payme = {
    'create_cards': "Произошла ошибка при отправке вашых данных".tr,
    'verify': "Введенный код неверен, попробуйте ещё раз".tr,
    "get_verify": "Не удалось отправить код. Попытайтесь позже".tr,
    "time_get_verify":
        "Пожалуйста подождите некоторое время перед отправкой кода ещё раз".tr,
    "not_sent_get_verify": "Не удалось отправить код! Попытайтесь позже".tr,
    -31900: "Данный тип карты не обслуживается.".tr,
    -31300: "Неверно указана дата истечения срока действия карты".tr,
    -31001: "Не подключено смс-информирование.".tr,
    -31300: "Карта с таким номером не найдена".tr,
  };

  static void handlePayme(Map errors, String elseThrow) {
    String throwing = "";
    try {
      throwing = payme[errors['error']['code']];
    } catch (e) {
      print(e);
      throw elseThrow;
    }
    throw throwing;
  }
}
