
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class DropDownInformation extends StatefulWidget {
  final String mainText;
  final String descriptionText;
  DropDownInformation({Key key,this.mainText,this.descriptionText}):super(key: key);
  @override
  _DropDownInformationState createState() => _DropDownInformationState(
    mainText: mainText,
    descriptionText: descriptionText,
  );
}

class _DropDownInformationState extends State<DropDownInformation> {
  final String mainText;
  final String descriptionText;
  _DropDownInformationState({this.descriptionText,this.mainText});
  bool pressed = false;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        setState(() {
          pressed=!pressed;
          if(pressed == false)
          _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(milliseconds: 400), curve: Curves.linear);
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(bottom: width*0.02),
        duration: Duration(milliseconds: 600),
        height: pressed?width*0.5:width*0.15,
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(width*0.02),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal:width*0.02,vertical: width*0.05),
          child: SingleChildScrollView(
            physics: pressed?AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            controller:_scrollController,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainText,
                      style: TextStyle(
                        color: HexColor("#42424A"),
                        fontFamily: 'Montserrat',
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,),),
                    SvgPicture.asset("assets/arrow_down.svg"),
                  ],
                ),
                SizedBox(
                  height: width*0.1,
                ),
                Text(descriptionText,
                  style: TextStyle(
                    color: HexColor("#42424A"),
                    fontFamily: 'Montserrat',
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
