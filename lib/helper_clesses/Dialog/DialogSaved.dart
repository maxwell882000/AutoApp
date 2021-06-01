import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/Dialog/AlertDialogsInfromation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';

class DialogSaved extends StatelessWidget {
  final String text;

  DialogSaved({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialogInformation(
      text: '${"Вы можете посмотреть в папке".tr} $text',
      title: 'Ваши данные сохранены',
    );
  }
}
