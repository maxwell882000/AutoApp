import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/statefull_wrapper.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class TextFieldHelper extends StatelessWidget {
  final Widget suffixIcon;
  final Widget prefixIcon;
  final bool onlyInteger;

  TextFieldHelper({Key key, this.suffixIcon, this.prefixIcon, this.onlyInteger = false})
      : super(key: key);



  final controller = TextEditingController();



  ErrorMessageProvider provider;

  int maxLength = 40;




  void controllerListener(context) {
    controller.addListener(() {
      String text = "";
      final provider = Provider.of<ErrorMessageProvider>(context, listen: false);
      if (controller.text.length <= maxLength) {
        text = controller.text;
      } else {
        controller.text = text;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
      provider.setInputData(controller.text);
      provider.setTextField(true);
      provider.setSelected(controller.text.isNotEmpty ? true : false);
      if (controller.text.isNotEmpty) {
        provider.setError(false);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return StatefulWrapper(
      onInit: ()=>controllerListener(context),
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Consumer<ErrorMessageProvider>(
          builder: (context, provider, child) {
            return TextField(
              scrollPhysics: AlwaysScrollableScrollPhysics(),
              controller: controller,
              cursorColor: Color.fromRGBO(66, 66, 74, 1),
              cursorHeight: width * 0.045,
              textAlign: TextAlign.left,
              autocorrect: false,
              maxLines: 1,
              style: TextStyle(
                fontSize: width * 0.04,
                fontFamily: "Roboto",
                color: Color.fromRGBO(66, 66, 74, 1),
              ),
              decoration: new InputDecoration(

                suffixIcon: provider.recommendations != null
                    ? provider.inputData.isNotEmpty ? null : provider
                    .recommendations
                    : suffixIcon,
                prefixIcon: prefixIcon,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                counterText: '',
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: width * 0.035),
                labelText: provider.nameOfHelper,
                labelStyle: TextStyle(
                  fontSize: width * 0.03,
                  fontFamily: "Roboto",
                  color: Color.fromRGBO(66, 66, 74, 1),
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: !provider.error
                          ? Color.fromRGBO(127, 165, 201, 1)
                          : Color.fromRGBO(223, 88, 103, 1),
                      width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: !provider.error
                          ? Color.fromRGBO(127, 165, 201, 1)
                          : Color.fromRGBO(223, 88, 103, 1),
                      width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                ),
              ),
              keyboardType: onlyInteger ? TextInputType.number : TextInputType
                  .text,
              inputFormatters: onlyInteger ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ] : [],
            );
          }
        ),
      ),
    );
  }
}
