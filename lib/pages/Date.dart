
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter_projects/helper_clesses/AnimatedContainerBorder.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';
import 'package:flutter_projects/helper_clesses/Dialog/CustomDialog.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Date extends StatefulWidget {
  Date({Key key}):super(key: key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  String year;
  @override
  Widget build(BuildContext context) {
    List<Widget> years = [];
    final double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<ErrorMessageProvider>(context);
    List.generate(50, (index) => years.add(
        Center(
          child: Text("${index+1972}",
            style: TextStyle(
              color: HexColor("#42424A"),
              fontFamily: 'Montserrat',
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    ));
    return  AnimatedContainerBorder(
      duration: 300,
      height: width*0.12,

      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.infinite
        ),
        onPressed: () =>{
          CustomDialog.dialog(
            width: width,
            context: context,
            child: Container(
              margin: EdgeInsets.all(width*0.02),
              height: width*0.5,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Buttons(
                        onPressed: (context) {
                          if (year != null) {
                            provider.setError(false);
                            provider.setNameOfHelper(year);
                            provider.setInputData(year);
                          }
                          Navigator.of(context).pop();
                          },
                      nameOfTheButton: "Готово".tr,
                      height: width*0.75,
                      width: width*0.3,
                      hexValueOFColor: "#7FA6C9",
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: years.length.toDouble(),
                      onSelectedItemChanged: (select){
                        setState(() {
                          print(select);
                          year = "${select+1972}";
                          provider.setSelected(true);
                        });
                      },
                      children: years,
                    ),
                  ),
                ],
              ),
            ),
            alignment: Alignment.bottomLeft
          )
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(provider.nameOfHelper,
          textAlign: TextAlign.left,
          style:TextStyle(
            color: Color.fromRGBO(66, 66, 74, 1),
            fontFamily: "Roboto",
            fontSize: width * 0.03,
          ),
          ),
        ),
      ),
    );
  }
}
