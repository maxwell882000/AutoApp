
import 'package:flutter/material.dart';

class TextFlexible extends StatelessWidget {
  final String text;
  final int numberOfCharacters;

  TextFlexible({Key key , this.text, this.numberOfCharacters = 25}):super(key: key);
  // TextSpan preparedText(double width){
  //    List grouped = text.split(" ");
  //    print('Grouped $grouped');
  //    String temp = "";
  //    List prepared=[];
  //    List<TextSpan> spannedText;
  //    List.generate(grouped.length, (index) => {
  //       if(temp.length + grouped[index].length <= numberOfCharacters){
  //           temp = "$temp ${grouped[index]}",
  //           print("Temp $temp $index"),
  //       }else{
  //           prepared.add(temp),
  //         print(prepared),
  //         temp=grouped[index]
  //       }
  //    });
  //    prepared.add(temp);
  //    print(prepared);
  //   spannedText = prepared.map((element) =>
  //     TextSpan(
  //     text: '\n$element',
  //     style: TextStyle(
  //     color: Color.fromRGBO(66, 66, 74, 1),
  //     fontFamily: "Montserrat",
  //     fontSize: width * 0.035,
  //     fontWeight: FontWeight.bold,
  //     ),
  //     )
  //   ).toList();
  //   return TextSpan(
  //   children: spannedText
  //   );
  // }

  String fromatedString(){
    List grouped = text.split(" ");

    String temp = "";
    List prepared=[];
    String spannedText;
    List.generate(grouped.length, (index) => {
      if(temp.length + grouped[index].length <= numberOfCharacters){
        temp = "$temp ${grouped[index]}",
      }else{
        prepared.add(temp),
        temp=grouped[index]
      }
    });
    prepared.add(temp);
    temp = '';
    prepared.forEach((e) => temp ='$temp \n$e');
    spannedText = temp;
    return spannedText;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Text(
      fromatedString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromRGBO(66, 66, 74, 1),
        fontFamily: "Montserrat",
        fontSize: width * 0.035,
        fontWeight: FontWeight.bold,
      ),
    );
  }

}
