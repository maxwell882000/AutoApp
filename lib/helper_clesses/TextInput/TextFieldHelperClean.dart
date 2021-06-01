import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldHelperClean extends StatelessWidget {
  final String nameOfHelper;
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatter;
  final Function onSave;
  final Function onValidate;
  const TextFieldHelperClean({Key key,this.nameOfHelper, this.textInputType,this.textInputFormatter,this.onSave, this.onValidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: TextFormField(
                scrollPhysics: AlwaysScrollableScrollPhysics(),
                validator:(text)=>onValidate(text),
                onSaved: (text)=>onSave(text),
                cursorColor: Color.fromRGBO(66, 66, 74, 1),
                cursorHeight: Get.width * 0.045,
                textAlign: TextAlign.left,
                autocorrect: false,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Get.width * 0.04,
                  fontFamily: "Roboto",
                  color: Color.fromRGBO(66, 66, 74, 1),
                ),
                decoration: new InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  counterText: '',
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.02, vertical: Get.width * 0.035),
                  labelText:nameOfHelper,
                  labelStyle: TextStyle(
                    fontSize: Get.width * 0.03,
                    fontFamily: "Roboto",
                    color: Color.fromRGBO(66, 66, 74, 1),
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Color.fromRGBO(127, 165, 201, 1) ,
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.02)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Color.fromRGBO(223, 88, 103, 1),
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.02)),
                  ),
                  errorBorder:OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Color.fromRGBO(223, 88, 103, 1),
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.02)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(127, 165, 201, 1),
                        width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.02)),
                  ),
                ),
                keyboardType: textInputType,
                inputFormatters: textInputFormatter,
              )
      );
}
  // C
  // onlyInteger ? <TextInputFormatter>[
  // FilteringTextInputFormatter.digitsOnly
  // ] : [],

  }
