import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:hexcolor/hexcolor.dart';

import '../LoadingScreen.dart';

class Recomendation extends StatefulWidget {
  final Widget child;

  Recomendation({Key key, this.child}):super(key: key);

  @override
  _RecomendationState createState() => _RecomendationState();
}

class _RecomendationState extends State<Recomendation> {
  Uint8List image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SingletonConnection().recommendImage().then((value) {
      if(mounted)
      setState(() {
        image =  SingletonRecomendation().imageUnit;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(width*0.05),
      child: Column(
        children: [
          Container(
            height: width*0.45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(width*0.02),
          ),
            child: Container(
              margin: EdgeInsets.all(width*0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: image==null?LoadingScreen(
                        visible: true,
                        color: "F0F8FF",
                      ): Image.memory(
                       image,
                        fit: BoxFit.fill,
                      )
                  ),
                  SizedBox(
                    width: width*0.04,
                  ),
                  Expanded(child: Text("${SingletonRecomendation().textAbove}",
                    style: TextStyle(
                      color: HexColor("#42424A"),
                      fontFamily: 'Montserrat',
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: width*0.04,
          ),
         widget.child
        ],
      ),
    );
  }
}
