import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonGlobal.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';
import 'package:flutter_projects/helper_clesses/ChildAndButton.dart';
import 'package:flutter_projects/helper_clesses/DropDown/DropDownItem.dart';
import 'package:flutter_projects/helper_clesses/InitialPointOfAccount/Base.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
class Language extends StatelessWidget {
  Language({Key key}) : super(key: key);

  final List items = ["Русский Язык", "O`zbek tilli"];

  final ErrorMessageProvider errorsMessage =
      new ErrorMessageProvider("Выберите Язык".tr);

  void selectLanguage(String choosenLanguage) {
    if (errorsMessage.nameOfHelper == choosenLanguage) {
      SingletonGlobal().setLanguageSecond( Languages.EMPTY);
      return;
    } else if (choosenLanguage == items[0]) {
      SingletonGlobal().setLanguageSecond(Languages.RUSSIAN);
    } else {
      SingletonGlobal().setLanguageSecond(Languages.UZBEK);
    }
  }

  void selectedLanguage(BuildContext context) {
    print(errorsMessage.inputData);
    selectLanguage(errorsMessage.inputData);
    if (!errorsMessage.selected) {
      errorsMessage.setError(true);
      errorsMessage.setNameOfHelper("Сперва Выберите Языке!".tr);
    } else {
      errorsMessage.setNextPage(true);
      SingletonGlobal().saveLanguage();
      Navigator.of(context).popAndPushNamed('/select');
    }
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<ErrorMessageProvider>.value(
      value: errorsMessage,
      child: Base(
        width: width,
        height: width * 0.9,
        icon: "assets/languages.svg",
        aboveText: "Выбор Языка".tr,
        child: ChildAndButton(
          key: UniqueKey(),
          aboveChild: DropDownItem(
            items: items,
            width: width,
            uzbekFlag: "assets/uzbekistan.svg",
            russionFlag: "assets/russion.svg",
            disabledHeight: width * 0.11,
            enabledHeight: width * 0.25,
          ),
          button: Buttons(
            hexValueOFColor: "#7FA6C9",
            nameOfTheButton: "Готово",
            onPressed: this.selectedLanguage,
            height: width,
          ),
          heightOfButton: width * 0.005,
          size: EdgeInsets.only(
              top: width * 0.04, left: width * 0.08, right: width * 0.08),
          width: width,
        ),
      ),
    );
  }
}
