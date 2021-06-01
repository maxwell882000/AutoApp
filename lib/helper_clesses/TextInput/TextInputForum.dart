
import 'package:flutter/material.dart';

import 'package:flutter_projects/helper_clesses/InitialPointOfAccount/Base.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:provider/provider.dart';

import '../Buttons.dart';
import '../ChildAndButton.dart';
import 'TextFieldHelper.dart';

class TextInputForum extends StatelessWidget {
  final String svgPicture;
  final String aboveText;
  final String nameOfButton;
  final Function connectDataBase;

  TextInputForum(
      {Key key,
      this.svgPicture,
      this.aboveText,
      this.nameOfButton,
      this.connectDataBase})
      : super(key: key);

  final ErrorMessageProvider errorMessageProvider =
      new ErrorMessageProvider("Введите Email или Номер телефона");
//r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.(\w)" mail
  void registerAccount(BuildContext context) async {
    if (errorMessageProvider.inputData.isNotEmpty) {
      RegExp firstCases = new RegExp(r"(\+|(\d))");
      RegExp mail = new RegExp(r"[\w-\.]+@([\w-]+\.)+[\w-]");
      bool match = firstCases.hasMatch(errorMessageProvider.inputData[0]);
      bool mailCheck =mail.hasMatch(errorMessageProvider.inputData);
      print("mailCheck $mailCheck");
      if(mailCheck){
        match = false;
      }
      if (match) {
        RegExp exp = new RegExp(r"\+([8-9]{3,3})(\d{9,9})");
        bool match = exp.hasMatch(errorMessageProvider.inputData);
        if (match && errorMessageProvider.inputData.length==13) {
          errorMessageProvider.setError(false);
          errorMessageProvider.setNextPage(true);
          connectDataBase(
              errorMessageProvider.inputData, "phone", errorMessageProvider);
        } else {
          errorMessageProvider.setError(true);
          errorMessageProvider
              .setNameOfHelper("Номер телефона в формате: +998ХХХХХХХХХ ");
        }
      } else {
        RegExp exp = mail;
        bool match = exp.hasMatch(errorMessageProvider.inputData);
        if (match) {
          errorMessageProvider.setError(false);
          errorMessageProvider.setNextPage(true);
          connectDataBase(
              errorMessageProvider.inputData, "email", errorMessageProvider);
        } else {
          errorMessageProvider.setError(true);
          errorMessageProvider
              .setNameOfHelper("Пожалуйста введите правильный Email");
        }
      }
    } else {
      errorMessageProvider.setError(true);
      errorMessageProvider.setNameOfHelper("Необходимо заполнить");
    }
  }

  void setHintText() {
    if (!errorMessageProvider.error)
      errorMessageProvider.setNameOfHelper("Введите Email или Номер телефона");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: errorMessageProvider,
      child: Base(
        width: width,
        height: width * 0.9,
        icon: svgPicture,
        aboveText: aboveText,
        child: ChildAndButton(
          width: width,
          aboveChild: TextFieldHelper(),
          button: Buttons(
            hexValueOFColor: "#7FA6C9",
            nameOfTheButton: nameOfButton,
            onPressed: registerAccount,
            height: width,
          ),
          size:
              EdgeInsets.fromLTRB(width * 0.15, width * 0.08, width * 0.15, 0),
          heightOfButton: width * 0.005,
        ),
      ),
    );
  }
}
