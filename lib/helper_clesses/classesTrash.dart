// class ListAllChoices extends StatelessWidget {
//   final List itemsSpeed = ["Киллометр в секунду", "Метр в секунду"];
//   final double width;
//   ListAllChoices({Key key, this.width}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Скорость"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Растояние"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Расход Топлива"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Валюта"),
//         ),
//       ],
//     );
//   }
// }

// class ListAllChoices extends StatelessWidget {
//   final List itemsSpeed = ["Киллометр в секунду", "Метр в секунду"];
//   final double width;
//   ListAllChoices({Key key, this.width}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Скорость"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Растояние"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Расход Топлива"),
//         ),
//         SizedBox(
//           height: width * 0.04,
//         ),
//         ListDropDownWithTextHelper(
//           items: itemsSpeed,
//           width: width,
//           textHelper: Text("Валюта"),
//         ),
//       ],
//     );
//   }
// }

//import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hexcolor/hexcolor.dart';

// class DropDownHelper extends StatefulWidget {
//   final List items;
//   final String nameOfHelper;
//   final double width;
//   final String russionFlag;
//   final String uzbekFlag;
//   DropDownHelper(
//       {Key key,
//       this.items,
//       this.nameOfHelper,
//       this.width,
//       this.russionFlag = "",
//       this.uzbekFlag = ""})
//       : super(key: key);

//   @override
//   _DropDownHelperState createState() => _DropDownHelperState(
//       items: items,
//       nameOfHelper: nameOfHelper,
//       width: width,
//       russionFlag: russionFlag,
//       uzbekFlag: uzbekFlag);
// }

// class _DropDownHelperState extends State<DropDownHelper> {
//   final List items;
//   final String nameOfHelper;
//   final double width;
//   String choosenItem;
//   final String russionFlag;
//   final String uzbekFlag;
//   _DropDownHelperState(
//       {this.items,
//       this.nameOfHelper,
//       this.width,
//       this.russionFlag,
//       this.uzbekFlag});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(width*0.01),
//       decoration: BoxDecoration(
//         border: Border.all(color: HexColor("#7FA6C9"), width: 1.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButton(
//         hint: Text(nameOfHelper),
//         dropdownColor: Colors.white,
//         icon: Icon(Icons.arrow_drop_down_rounded),
//         iconSize: 20,
//         value: choosenItem,
//         isExpanded: true,
//         style: TextStyle(color: Colors.black),
//         underline: SizedBox(),
//         onChanged: (newValue) {
//           setState(() {
//             choosenItem = newValue;
//           });
//         },
//         items: items
//             .map((valueItem) => DropdownMenuItem(
//                   child: uzbekFlag.isEmpty
//                       ? Text(valueItem)
//                       : Row(
//                           children: [
//                             SvgPicture.asset(
//                               valueItem == items[0] ? russionFlag : uzbekFlag,
//                               width: width * 0.08,
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(valueItem),
//                           ],
//                         ),
//                   value: valueItem,
//                 ))
//             .toList(),
//       ),
//     );
//   }
// }

// class DropDownWithTextHelper extends StatelessWidget {
//   final Text textHelper;
//   final DropDownHelper dropdownButtonHelper;
//   final double width;
//   const DropDownWithTextHelper(
//       {Key key, this.textHelper, this.dropdownButtonHelper, this.width})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print(textHelper.data);
//     print(width);
//     print(dropdownButtonHelper.nameOfHelper);
//     return Container(
//       width: double.infinity,
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         textHelper,
//         Container(width: width * 0.5, child: dropdownButtonHelper),
//       ]),
//     );
//   }
// }

// class ListDropDownWithTextHelper extends StatelessWidget {
//   final Text textHelper;
//   final List items;
//   final double width;

//   ListDropDownWithTextHelper({Key key, this.textHelper, this.items, this.width})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DropDownWithTextHelper(
//       textHelper: textHelper,
//       dropdownButtonHelper: DropDownHelper(
//         items: items,
//         nameOfHelper:"Выберите " + textHelper.data,
//         width: width,
//       ),
//       width: width,
//     );
//   }
// }
