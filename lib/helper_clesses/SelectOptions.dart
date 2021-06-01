
import 'package:flutter/material.dart';


import 'InitialPointOfAccount/Base.dart';
import 'Buttons.dart';
import 'ChildAndButton.dart';

class SelectOptions extends StatelessWidget {
  final double width;
  final double height;
  final String icon;
  final String aboveText;
  final double heightOfButton;
  final double widthOfButton;
  final Widget child;
  final Function loadToHard;
  final Function clickEvent;

  SelectOptions({
    Key key,
    this.aboveText,
    this.child,
    this.height,
    this.icon,
    this.width,
    this.heightOfButton,
    this.widthOfButton,
    this.loadToHard,
    this.clickEvent,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Base(
      width: width,
      height: height,
      icon: icon,
      aboveText: aboveText,
      child: ChildAndButton(
        width: width,
        heightOfButton: heightOfButton,
        widthOfButton: widthOfButton,
        size: EdgeInsets.fromLTRB(
            width * 0.03, width * 0.03, width * 0.03, width * 0.02),
        aboveChild: child,
        button: Buttons(
          width: width * 0.4,
          hexValueOFColor: "#7FA6C9",
          nameOfTheButton: "Готово",
          height: width,
          onPressed: clickEvent(loadToHard),
        ),
      ),
    );
  }
}
