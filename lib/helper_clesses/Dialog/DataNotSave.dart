import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class DataNotSave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Text(
        'Вы уверены что хотите выйти',
        style: TextStyle(
          color: HexColor("#42424A"),
          fontFamily: 'Montserrat',
          fontSize: width * 0.035,
        ),
      ),
      title: Text(
        'Ваши данные не сохраняться',
        style: TextStyle(
          color: HexColor("#42424A"),
          fontFamily: 'Montserrat',
          fontSize: width * 0.035,
          fontWeight: FontWeight.bold,
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
