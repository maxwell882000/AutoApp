
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  final bool visible;
  final String color;
  final double size;
  const LoadingScreen({Key key, this.visible, this.color,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: visible,
      child: Center(
        child: Container(
          width:size !=null?size: width * 0.3,
          height:size !=null?size: width * 0.3,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                color != null ? HexColor(color) : Colors.white),
            strokeWidth: width * 0.05,
          ),
        ),
      ),
    );
  }
}
class LoadingScreenWithScaffold extends StatelessWidget {
  final bool visible;
  final String color;
  final double size;
  const LoadingScreenWithScaffold({Key key, this.visible, this.color,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor("F0F8FF"),
      body: Center(
        child: Visibility(
          visible: visible,
          child: Container(
            width:size !=null?size: width * 0.3,
            height:size !=null?size: width * 0.3,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  color != null ? HexColor(color) : Colors.white),
              strokeWidth: width * 0.05,
            ),
          ),
        ),
      ),
    );
  }
}
