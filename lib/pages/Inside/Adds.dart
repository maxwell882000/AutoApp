
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonAdds.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/helper_clesses/Dialog/GoToAdd.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Adds extends StatefulWidget {
  @override
  _AddsState createState() => _AddsState();
}
class _AddsState extends State<Adds> {

  Widget adds = SizedBox();
  double height = 0;
  Widget getAdd(){
    double width = MediaQuery.of(context).size.width;
   return Stack(
     children: <Widget>[
       GestureDetector(
         onTap: (){
          GoToAdd.goToAdd(
            context:context,
            width: width,
            site: SingletonAdds().links
          );
         },
         child: Container(
           width: width,
           height: width,
           child: ClipRRect(
             borderRadius: BorderRadius.circular(width*0.01),
             child: Image.memory(
               SingletonAdds().image,
               fit:BoxFit.fill,
             ),
           ),
         ),
       ),
       Align(
         alignment: Alignment.topRight,
         child: GestureDetector(
           onTap: (){
             setState(() {
               height = 0;
             });
           },
           child: SvgPicture.asset(
             "assets/cross.svg",
             height: width * 0.07,
           ),
         ),
       ),
     ],
   );
  }
  @override
  void initState() {
   super.initState();

     SingletonConnection().loadAdds().then((value) {
       double width = MediaQuery
           .of(context)
           .size
           .width;
       setState(() {
         adds = getAdd();
         height = width * 0.3;
       });
     });

  }
  @override
  Widget build(BuildContext context) {

    return  Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: height,
                margin: EdgeInsets.only(top: height*0.1),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: adds,
              ),
            ),
          ],
    );
  }
}
