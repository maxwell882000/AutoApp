import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class Buttons extends StatelessWidget {
  final String nameOfTheButton;
  final String hexValueOFColor;
  final Function onPressed;
  final double height;
  final String icons;
  final double width;
  Buttons({
    Key key,
    this.hexValueOFColor,
    this.nameOfTheButton,
    this.onPressed,
    this.height,
    this.icons = "",
    this.width = 0,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      buttonColor: HexColor(hexValueOFColor),
      minWidth: width != 0.0 ? width : double.infinity,
      height: height * 0.135,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.02)),
      child: RaisedButton(
          onPressed: () => onPressed(context),
          child: icons.isEmpty
              ? Text(
                  nameOfTheButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                  ),
                )
              : Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        icons,
                        width: height * 0.06,
                      ),
                      SizedBox(
                        width: height * 0.04,
                      ),
                      Text(
                        nameOfTheButton,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
