import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class BackGroundMoving extends StatefulWidget {
  final String backGround;
  final String object;
  final double width;
  final double height;
  BackGroundMoving({
    Key key,
    this.backGround,
    this.object,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _BackGroundMovingState createState() => _BackGroundMovingState(
        backGround: backGround,
        object: object,
        width: width,
        height: height,
      );
}

class _BackGroundMovingState extends State<BackGroundMoving> {
  final String backGround;
  final String object;
  final double width;
  final double height;

  double positionOfCar;
  double positionOfBackGround;

  double sizeOfCar;

  double firstBack = 0;
  double secondBack = 0;
  var padding;
  double height1;
  _BackGroundMovingState({
    this.backGround,
    this.object,
    this.width,
    this.height,
  });

  @override
  void initState() {
    super.initState();
   animationMovement(context);
  }

  void animationMovement(BuildContext context) {
    secondBack = -width + 2;
    print(mounted);
    if (mounted) {
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (mounted) {
          setState(() {
            if (firstBack >= width - 2) {
              firstBack = -width + 2;
            }
            if (secondBack >= width - 2) {
              secondBack = -width + 2;
            }
            firstBack += 1;
            secondBack += 1;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: firstBack,
          width: width,
          height: width * 0.6,
          child: SvgPicture.asset(
            backGround,
            width: width,
            height: width * 0.6,
          ),
        ),
        Positioned(
          right: secondBack,
          width: width,
          height: width * 0.6,
          child: SvgPicture.asset(
            backGround,
            width: width,
            height: width * 0.6,
          ),
        ),
        Positioned(
          height: width,
          width: width*0.25,
          child: SvgPicture.asset(
            object,
          ),
        ),
      ],
    );
  }
}
