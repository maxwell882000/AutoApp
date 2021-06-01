import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';

import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';

import 'package:flutter_projects/helper_clesses/TextInput/TextFieldHelperClean.dart';

import 'package:get/get.dart';

import 'GetXControllers/payme_controller.dart';

class CodeVerification extends StatelessWidget {
  final _formKey = new GlobalKey<FormState>();

  CodeVerification({Key key}) : super(key: key);

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
          child: GetBuilder<PaymeController>(
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
                      Text(
                        "Код подтверждения отправлен на ваш телефон. Пожалуйста введите его!"
                            .tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFieldHelperClean(
                          nameOfHelper: "Введите код",
                          onSave: _.setCode,
                          onValidate:_.validateCode,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Buttons(
                          nameOfTheButton: "Отправить".tr,
                          hexValueOFColor: "#7FA6C9",
                          height: Get.height * 0.5,
                          width: Get.width * 0.5,
                          onPressed: (context) {
                            _.sendCode(_formKey);
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                            onPressed: () {
                              _.resendCode();
                            },
                            child: Text("Отправить код повторно".tr)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
