import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChoiceDialog extends StatelessWidget {
  final String text;
  ChoiceDialog({Key key, this.text}):super(key: key);
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Text(
        text,
        style: TextStyle(
          color: HexColor("#42424A"),
          fontFamily: 'Montserrat',
          fontSize: width * 0.035,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Да'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text('Нет'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
