
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/Check.dart';


import 'package:hexcolor/hexcolor.dart';

class CheckAgreement extends StatelessWidget {
  final double width;
  final Function onTap;
  CheckAgreement({Key key, this.width, this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Container(
        width: width,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Check(
              onTap: onTap,
            ),
            SizedBox(
              width: width * 0.04,
            ),
            Container(
              width: width * 0.6,
              child: Wrap(direction: Axis.horizontal, children: [
                Text(
                  "Я ознакомился и соглашаюсь с ",
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#42424A"),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "Правилами пользования",
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: "Montserrat",
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
