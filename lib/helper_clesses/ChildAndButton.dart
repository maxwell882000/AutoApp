import 'package:flutter/material.dart';

import 'Buttons.dart';

class ChildAndButton extends StatelessWidget {
  final Widget aboveChild;
  final Buttons button;
  final double width;
  final double widthOfButton;
  final double heightOfButton;
  final EdgeInsets size;
  final int flex;
  ChildAndButton({
    Key key,
    this.width,
    this.aboveChild,
    this.button,
    this.size,
    this.flex,
    this.widthOfButton,
    this.heightOfButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            heightFactor: heightOfButton,
            child: Container(
              height: width * 0.13,
              child: button,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
            ),
            child: aboveChild,
          ),
        ],
      ),
    );
  }
}
