// import 'package:TestApplication/HelperClasses/InsideOfAccount/AbovePartOfAccount.dart';
// import 'package:TestApplication/HelperClasses/InsideOfAccount/AppBarForAccount.dart';
// import 'package:TestApplication/HelperClasses/InsideOfAccount/ListOfInicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// import 'MainMenu.dart';
//
// class BaseOfAccount extends StatefulWidget {
//   final Widget child;
//   const BaseOfAccount({Key key, this.child}) : super(key: key);
//
//   @override
//   _BaseOfAccountState createState() => _BaseOfAccountState();
// }
//
// class _BaseOfAccountState extends State<BaseOfAccount> {
//   List indicators = [
//     ["Замена Моторного Масла", 23.0],
//     ["Замена X Фильтров", 30.0],
//     ["Замена Aнтифриза", 15.0],
//     ["Проверка генератора", 21.0],
//     ["Проверка генератора", 5.0],
//   ];
//
//   List logic(double dataToBeHandled, double width) {
//     Color color;
//     double widthOfIndicator;
//
//       int dataHandle = (dataToBeHandled / 10).floor();
//       switch (dataHandle) {
//         case 0:
//           color = Color.fromRGBO(165, 235, 120, 1);
//           break;
//         case 1:
//           color = Color.fromRGBO(255, 204, 51, 1);
//           break;
//         default:
//           color = Color.fromRGBO(223, 88, 103, 1);
//           break;
//       }
//       widthOfIndicator = width * dataToBeHandled/ 30;
//
//     return [color, widthOfIndicator];
//   }
//
//
//   Function logicForIndicators;
//   @override
//   void initState() {
//     super.initState();
//     logicForIndicators = logic;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return MainMenu(
//       body: Container(
//         margin: EdgeInsets.symmetric(
//             vertical: width * 0.05, horizontal: width * 0.03),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           AbovePartOfAccount(
//             width: width,
//           ),
//           SizedBox(
//             height: width * 0.04,
//           ),
//           ListOfIndicator(
//               indicators: indicators,
//               logicForIndicator: logicForIndicators,
//             ),
//         ]),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.transparent,
//         onPressed: (){},
//         child: SvgPicture.asset("assets/add.svg",
//         height: width*0.13,
//         ),
//         ),
//     );
//   }
// }
