

import 'package:flutter/material.dart';

import '../AnimatedContainerBorder.dart';


class AnimationDropDownMenu extends StatelessWidget {
  final bool pressed;
  final double enabledHeight;
  final double width;
  final double disabledHeight;
  final dropDownWidget;
  final int scrolling;
  final bool visibility;
  final bool error;
  AnimationDropDownMenu({
    Key key,
    this.pressed,
    this.enabledHeight,
    this.width,
    this.disabledHeight,
    this.dropDownWidget,
    this.scrolling,
    this.visibility,
    this.error,
  }) : super(key: key);
  final ScrollController scroll = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: AnimatedContainerBorder(
        duration:pressed ? 1000 : 600,
        height: pressed ? enabledHeight : disabledHeight,
        child: Scrollbar(
          radius: Radius.circular(width*0.3),
          controller: scroll,
          isAlwaysShown: scrolling == 1
              ? true
              : false,
          child: SingleChildScrollView(
              controller: scroll,
              physics: scrolling == 1
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              child: Column(
                children: dropDownWidget.toList(),
              )),
        ),
      ),
    );
  }
}
