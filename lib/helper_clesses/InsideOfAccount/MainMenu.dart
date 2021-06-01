
import 'package:flutter/material.dart';
import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'AppBarForAccount.dart';

class MainMenu extends StatelessWidget {
  final Widget body;
  final Widget floatingActionButton;
  final Widget nameBar;
  final VisibilityClass visible;
  final int menu;
  MainMenu({Key key,
    this.body,
    this.floatingActionButton,
    this.nameBar,
   this.visible,
  this.menu = -10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    if(visible.filterVisible == false && menu == -10){
      return ChangeNotifierProvider(
        create:(BuildContext context) => UserProvider() ,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarForAccount(
            nameBar: this.nameBar,
            visible: visible,
          ),
          backgroundColor: HexColor("F0F8FF"),
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBarForAccount(
          nameBar: this.nameBar,
          visible: visible,
        ),
        backgroundColor: HexColor("F0F8FF"),
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }
}
