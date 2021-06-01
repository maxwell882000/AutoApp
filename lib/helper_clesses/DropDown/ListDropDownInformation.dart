
import 'package:flutter/cupertino.dart';

import 'DropDownInformation.dart';

class ListDropDownInformation extends StatelessWidget {
  final List items;

  ListDropDownInformation({Key key,this.items}):super(key: key);

  List<Widget> getListOfWidget(){
     return items.map((e) => DropDownInformation(
       mainText: e[0],
       descriptionText: e[1],
     )).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: getListOfWidget(),
    );
  }
}
