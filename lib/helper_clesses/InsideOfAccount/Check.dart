
import 'package:flutter/material.dart';
import 'package:flutter_projects/Provider/CheckProvider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Check extends StatelessWidget {
  final Function onTap;
  Check({Key key, this.onTap}):super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CheckProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return     GestureDetector(
      onTap:()=>onTap(),
      child: SvgPicture.asset(
        provider.checked ? "assets/checked.svg" : "assets/unchecked.svg",
        height: width * 0.05,
      ),
    );
  }
}
