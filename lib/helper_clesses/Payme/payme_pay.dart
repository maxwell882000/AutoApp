import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';

import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';

import 'package:flutter_projects/helper_clesses/TextInput/TextFieldHelperClean.dart';

import 'package:get/get.dart';

import 'GetXControllers/payme_controller.dart';

class PaymePay extends StatelessWidget {
  final PAYME_ICON = 'assets/payme.png';
  final _formKey = new GlobalKey<FormState>();
  final String amountId;

  PaymePay({Key key, this.amountId = '0'}) : super(key: key);

  void pay() {}

  Widget margin() {
    return SizedBox(
      width: Get.width * 0.02,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*0.4,
      margin: EdgeInsets.symmetric(horizontal: Get.width*0.1),
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
          body: Center(
              child: Form(
        key: _formKey,
        child: GetBuilder<PaymeController>(
          init: PaymeController(),
          builder: (_) => Stack(
            children: [
              LoadingScreen(
                visible: _.loading,
                color: "#7FA6C9",
              ),
              Visibility(
                visible: !_.loading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Номер карты".tr),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    TextFieldHelperClean(
                        nameOfHelper: "Введите номер карты",
                        onSave: _.setNumberCard,
                        onValidate: _.validateNumber),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Powered By"),
                            Image.asset(
                              PAYME_ICON,
                              fit: BoxFit.fitWidth,
                              width: Get.width * 0.2,
                            ),
                          ],
                        ),
                        margin(),
                        Text(
                          "Срок\nДействия".tr,
                        ),
                        margin(),
                        Expanded(
                            child: TextFieldHelperClean(
                          nameOfHelper: "Месяц/Год".tr,
                          onValidate: _.validateDate,
                          onSave: _.setDate,
                        ))
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Buttons(
                        nameOfTheButton: "Отправить".tr,
                        hexValueOFColor: "#7FA6C9",
                        height: Get.height * 0.5,
                        width: Get.width * 0.5,
                        onPressed: (context) {
                          _.formSubmit(_formKey, amountId);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ))),
    );
  }
}
