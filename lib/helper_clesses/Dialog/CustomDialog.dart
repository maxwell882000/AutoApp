import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/Dialog/AlertDialogsInfromation.dart';
import 'package:get/get.dart';

class CustomDialog {
  static Future dialog(
      {double width,
      BuildContext context,
      Widget child,
      bool barrierDismissible = true,
      Color color = Colors.white,
      Alignment alignment = Alignment.topCenter, double height}) {
    return showGeneralDialog(
        barrierColor: Colors.black54,
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Label',
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: alignment,
            child: SafeArea(
              child: Container(
                height: height,
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: width * 0.2),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(width * 0.02)),
                  child: child),
            ),
          );
        });
  }

  static Future show({String text, String title}) {
    return showDialog(
        context: Get.context,
        builder: (context) {
          return AlertDialogInformation(
            text: text,
            title: title,
          );
        });
  }

}
