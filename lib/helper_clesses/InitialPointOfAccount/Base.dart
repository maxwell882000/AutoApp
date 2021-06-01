
import 'package:flutter/material.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../LoadingScreen.dart';

class Base extends StatelessWidget {
  final Widget child;
  final double width;
  final String aboveText;
  final String icon;
  final double height;
  const Base({
    Key key,
    this.child,
    this.width,
    this.icon,
    this.aboveText,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<ErrorMessageProvider>(context);
    return Scaffold(
      backgroundColor: HexColor("#F0F8FF"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: LoadingScreen(
                  visible: provider.nextPage
                ),
              ),
              Visibility(
                visible: !provider.nextPage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.035),
                  ),
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
                  width: width,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    width: width,
                    padding: EdgeInsets.all(0),
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.fromLTRB(
                              width * 0.09, width * 0.12, width * 0.09, 0),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  icon,
                                  height: width * 0.15,
                                ),
                              ),
                              Text(
                                aboveText,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: width * 0.06,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(66, 66, 74, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
