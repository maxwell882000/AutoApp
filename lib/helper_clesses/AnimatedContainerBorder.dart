
import 'package:flutter/material.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AnimatedContainerBorder extends StatelessWidget {
  final int duration;
  final double width;
  final double height;
  final Widget child;
  AnimatedContainerBorder({
    Key key,
    this.width,
    this.height,
    this.duration,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var error = Provider.of<ErrorMessageProvider>(context);
    return AnimatedContainer(
      curve:  Curves.easeInOut,
      duration: Duration(milliseconds: duration),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
            color: !error.error ? HexColor("#7FA6C9") : HexColor("#DF5867"),
            width: 1.2),
        borderRadius:
        BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
      ),
      child: child,
    );
  }
}
