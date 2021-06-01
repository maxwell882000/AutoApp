
import 'package:flutter/material.dart';
import 'package:flutter_projects/Singleton/SingletonGetX.dart';
import 'package:flutter_projects/controller/controller_cards.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'AnimationDropDownMenu.dart';

class DropDownItem extends StatefulWidget {
  final List items;
  final String russionFlag;
  final String uzbekFlag;
  final double width;
  final double disabledHeight;
  final double enabledHeight;
  final Function additionalItemsFunction;
  final Widget iconsAddition;
  const DropDownItem({
    Key key,
    this.items,
    this.russionFlag = "",
    this.uzbekFlag = "",
    this.width,
    this.disabledHeight,
    this.enabledHeight,
    this.additionalItemsFunction,
    this.iconsAddition,
  }) : super(key: key);

  @override
  _DropDownItemState createState() => _DropDownItemState(
        items: items,
        russionFlag: russionFlag,
        uzbekFlag: uzbekFlag,
        width: width,
        disabledHeight: disabledHeight,
        enabledHeight: enabledHeight,
        additionalItemsFunction: additionalItemsFunction==null?(element){}:additionalItemsFunction,
    iconsAddition: iconsAddition,
      );
}

class _DropDownItemState extends State<DropDownItem> {
  // getting from outside
  final List items;
  final String russionFlag;
  final String uzbekFlag;
  final double width;
  final double disabledHeight;
  final double enabledHeight;
  final Function additionalItemsFunction;
  final Widget iconsAddition;

  // inside
  List connectAll;
  bool visibility = true;
  var dropDownWidget;
  int scrolling = 0;
  bool pressed = false;
  var hintText;
  var errorProvider;
  bool initial = true;
  ErrorMessageProvider provider;
  //contsturctor
  _DropDownItemState({
    this.items,
    this.russionFlag = "",
    this.uzbekFlag = "",
    this.width,
    this.disabledHeight,
    this.enabledHeight,
    this.additionalItemsFunction,
    this.iconsAddition,
  });

  @override
  void initState() {
    super.initState();
  }

  void _updateState(double width, String choosenItem) {
    setState(() {
      scrolling++;

      if (scrolling == 2) {
        scrolling = 0;
        visibility = !visibility;
        print("HERE I AM CHOOSING");
        if(provider.inputData!=choosenItem) {
          additionalItemsFunction(choosenItem);
          provider.setInputData(choosenItem);
        }
      }


      pressed = !pressed;
    });
 
    if (provider.nameOfHelper != choosenItem) {
      provider.setSelected(true);
      provider.setError(false);
    }
  }

  void toGetList() {

    String choosenItem = provider.inputData;
    ErrorMessageProvider errorProvider = provider;
      if (((choosenItem==null||choosenItem.isEmpty) && initial) || connectAll == null ) {

        hintText = errorProvider.nameOfHelper;
        var temp1 = [
          [hintText],
          items.map((e) => e).toList(),
        ];
        var temp2 = temp1.expand((i) => i).toList();
        connectAll = temp2;
       Future.delayed(Duration(milliseconds: 100)).then((value) => provider.setInputData(""));
      } else if (errorProvider.error &&
          (choosenItem.isEmpty || choosenItem == hintText)) {
        hintText = errorProvider.nameOfHelper;
        connectAll[0] = hintText;
      } else
      if (choosenItem.isNotEmpty && connectAll != null) {
        connectAll.remove(choosenItem);
        connectAll.join(', ');
        connectAll.remove(hintText);
        connectAll.join(', ');
        connectAll.insert(0, choosenItem);
      }
      if (connectAll == null && choosenItem.isNotEmpty){

        connectAll = items;
        connectAll.remove(choosenItem);
        connectAll.join(', ');
        connectAll.insert(0, choosenItem);
      }

      dropDownWidget = connectAll==null?<Widget>[]:connectAll.map((e) => getChoices(e, width)).toList();
      initial = false;
  }

  Widget getChoices(String item, double width) {
    return TextButton(
      onPressed: () => _updateState(width, item),
      style: TextButton.styleFrom(
        primary: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item == hintText || russionFlag.isEmpty
              ? Flexible(
                  child: Text(
                    item ?? "",
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: width * 0.03,
                      fontFamily: "Roboto",
                      color: Color.fromRGBO(66, 66, 74, 1),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      item != items[0] ? uzbekFlag : russionFlag,
                      width: width * 0.05,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Flexible(
                      child: Text(
                        item,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: width * 0.03,
                          fontFamily: "Roboto",
                          color: Color.fromRGBO(66, 66, 74, 1),
                        ),
                      ),
                    )
                  ],
                ),
          Visibility(
            visible: scrolling == 0 ? true : false,
            child: iconsAddition!=null?iconsAddition:SvgPicture.asset(
              "assets/arrow_down.svg",
              width: width * 0.03,
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    provider = provider==null?Provider.of<ErrorMessageProvider>(context):provider;
    toGetList();

    return Stack(
      children: [
        AnimationDropDownMenu(
          pressed: pressed,
          enabledHeight: enabledHeight,
          width: width,
          disabledHeight: disabledHeight,
          dropDownWidget: dropDownWidget,
          scrolling: scrolling,
          visibility: visibility,
        ),
        AnimationDropDownMenu(
          pressed: pressed,
          enabledHeight: enabledHeight,
          width: width,
          disabledHeight: disabledHeight,
          dropDownWidget: dropDownWidget,
          scrolling: scrolling,
          visibility: !visibility,
        ),
      ],
    );
  }
}
