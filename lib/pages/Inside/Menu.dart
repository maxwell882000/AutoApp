import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonGlobal.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonRegistrationAuto.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/ChoiceDialog.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/MainMenu.dart';
import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';
import 'package:flutter_projects/helper_clesses/TextFlexible.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String chosenText;
  List items= [];
  final initialHeight = 0.14;
  final UserProvider userProvider = new UserProvider.start(
    SingletonUserInformation().run,
    SingletonUserInformation().average,
    SingletonUserInformation().cards.changeDetails,
    SingletonUserInformation().expenses.all_time,
    SingletonUserInformation().expenses.in_this_month,
    SingletonUserInformation().proAccount,
    "${SingletonUserInformation().marka} ${SingletonUserInformation().model}",
    "${SingletonUserInformation().number}",
    "${SingletonUserInformation().techPassport}",
    "${SingletonUserInformation().tenure()} лет",
    false,
  );
  double height = 0;
  final ScrollController _scrollController = ScrollController();
  bool check = true;
  bool loading = true;
  final GlobalKey _scaffoldKey = GlobalKey();
  Widget text({Color color, String text, double width}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: width * 0.038,
          color: color != null ? color : HexColor("#FFFFFF"),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void initState() {

    super.initState();
    userProvider.setProAccount(true);
    userProvider.setClearMenu(false);
    SingletonConnection().getTransports().then((value) {
      if(mounted) {
        setState(() {
          print(value);

          value.where((element) =>
          element['id'] != SingletonUserInformation().id).forEach((element) {
            items.add([element['nameOfTransport'], element['id']]);
          });

          height = initialHeight * items.length;
          loading = false;
        });
      }
    });
  }

  Widget choices(String text, var id, double width) {
    return SizedBox(
      height: width*0.15,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal:  0 , vertical: width*0.01),
        ),
          onPressed: () {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              );
              final Future response = showDialog(
                context: _scaffoldKey.currentContext,
                barrierDismissible: false,
                builder: (context) => ChoiceDialog(
                  text: "Вы уверены что хотите сменить карточку ?".tr,
                ),
              );
              response.then((value) {
                setState(() {
                  loading = true;
                  userProvider.setClearMenu(true);
                  userProvider.setClearSettings(true);
                });

                if (value) {
                  SingletonRecomendation().clean();
                  SingletonRegistrationAuto().clean();
                  SingletonUserInformation().cards.clean();
                  SingletonConnection()
                      .authorizedData(
                          text:
                              "${SingletonUserInformation().emailOrPhone}/?id_cards=$id")
                      .then((value) {
                          loading = false;

                          Navigator.of(_scaffoldKey.currentContext).pop(MenuPOP.CHANGE_TRANSPORT);
                  });
                }
                else{
                  setState(() {
                    loading = false;
                    check = true;
                    userProvider.setClearMenu(false);
                    userProvider.setClearSettings(false);
                  });
                }
              });
          },
          child: this.text(text: text, width: width)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    print("PRO ACCOUNT INSIDE MENU ${userProvider.proAccount}");
    print("${SingletonUserInformation().proAccount}");

    return ChangeNotifierProvider.value(
      value: userProvider,
      child: MainMenu(
        menu: 1,
        key: _scaffoldKey,
        visible: VisibilityClass(
          menuVisible: false,
          filterVisible: false,
          clearMenu: true,
        ),
        nameBar: TextFlexible(
          text: "Меню".tr,
          numberOfCharacters: 25,
        ),
        body: Container(
          margin: EdgeInsets.all(width * 0.05),
          child: Stack(
            children: [
              Visibility(
                  child: Center(
                    child: LoadingScreen(
                visible: loading,
              ),
                  )),
              Visibility(
                visible: !loading,
                child: Stack(
                  children: [
                    AnimatedContainer(
                        margin: EdgeInsets.only(top: width*0.03),
                        decoration: BoxDecoration(
                          color: HexColor("#7FA5C9"),
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        height: Get.height*0.95,
                        // height: check
                        //     ? 0
                        //     : height > 1.15
                        //         ? width * 1.15
                        //         : width * (0.25 + height),
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          margin: EdgeInsets.only(top: width * 0.2),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04, vertical: width * 0.04),
                          child: ListView.separated(
                            controller: _scrollController,
                            itemBuilder: (context, position) => choices(
                                items[position][0],
                                items[position][1],
                                width),
                            itemCount: items.length,
                            separatorBuilder: (context, position) {
                              return SizedBox(
                                height: width * 0.08,
                              );
                            },
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          check = !check;
                        });
                      },
                      child: Container(
                        height: width * 0.18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                                width: width,
                                text:
                                    "${SingletonUserInformation().nameOfTransport}",
                                color: HexColor("#42424A")),
                            // SvgPicture.asset("assets/arrow_down.svg"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: !loading,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {
              setState(() {
                loading = true;
              });
              if (SingletonUserInformation().proAccount) {
                final items = http.get(
                    '${SingletonConnection.URL}/marka/'
                );
                items.then((value) {
                  jsonDecode(value.body).forEach((e) =>
                      SingletonRegistrationAuto().fromJson(e));
                  SingletonRegistrationAuto().finish();
                  Navigator.of(_scaffoldKey.currentContext).popAndPushNamed(
                      "/registration_auto", arguments: MenuPOP.NEW_TRANSPORT);
                });
              }
            else {
                Navigator.of(_scaffoldKey.currentContext).popAndPushNamed(
                    "/pro_account");
              }
            },
            child: SvgPicture.asset(
              "assets/add.svg",
              height: width * 0.13,
            ),
          ),
        ),
      ),
    );
  }
}
