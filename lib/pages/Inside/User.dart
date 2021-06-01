import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonGlobal.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonRegistrationAuto.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/ChoiceDialog.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/AbovePartOfAccount.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/Indicator.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/MainMenu.dart';

import 'package:flutter_projects/helper_clesses/InsideOfAccount/ListOfInicator.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/get_x_widgets/controller/controllers.dart';
import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';
import 'package:flutter_projects/helper_clesses/TextFlexible.dart';
import 'package:flutter_projects/helper_clesses/statefull_wrapper.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'Adds.dart';

class User extends StatelessWidget {
  User({
    Key key,
  }) : super(key: key);
  final UserProvider userProvider = SingletonUserInformation().NO_ACCOUNT
      ? UserProvider.noAccount()
      : new UserProvider.start(
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

  @override
  void initState() {
    SingletonGlobal()
        .prefs
        .setString('user', SingletonUserInformation().emailOrPhone);
  }

  Future<bool> _onWillPop() async {
    bool response = await showDialog(
      context: Get.context,
      barrierDismissible: false,
      builder: (context) => ChoiceDialog(
        text: "Вы уверены что хотите выйти ?",
      ),
    );
    if (response) {
      if (SingletonUserInformation().pop) {
        response = false;
      }
      SingletonUserInformation().clean();
      SingletonRecomendation().clean();
      SingletonRegistrationAuto().clean();
      if (!response) {
        SingletonGlobal().prefs.remove("user");
        Navigator.of(Get.context).popAndPushNamed("/select");
      }
    }
    return response;
  }
  Widget getIndicators(List indicator) {
    return Indicator(
        key: UniqueKey(),
        textOfIndicator: indicator[0],
        dataPercent: indicator[1],
        dataTime: indicator[2],
        dataDistance: indicator[3],
        id: indicator[4]);
  }

  Future<List<Widget>> onload() async {
    await SingletonUserInformation().cards.loadCards();
    userProvider.setChangeDetails(0);
    List<Widget> allIndicators = [];
    userProvider.setIndicators(SingletonUserInformation().indicators());
    userProvider.setAverageRun(SingletonUserInformation().average);
    if (userProvider.indicators.isNotEmpty)
      allIndicators = userProvider.indicators.map((indicator) {
        double handle = indicator[1];
        int detail = userProvider.changeDetail;
        userProvider.setChangeDetails(handle > 0.8 ? 1 + detail : detail);
        return getIndicators(indicator);
      }).toList();
    userProvider.setLoading(false);
    return allIndicators;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: StatefulWrapper(
        onInit: initState,
        child: ChangeNotifierProvider.value(
          value: userProvider,
          child: Consumer<UserProvider>(builder: (context, userProvider, child) {
            return MainMenu(
              visible: VisibilityClass(
                filterVisible: true,
                menuVisible: true,
                clearMenu: true,
              ),
              nameBar: TextFlexible(
                text: "AUTOAPP",
                numberOfCharacters: 25,
              ),
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: !userProvider.NO_ACCOUNT || userProvider.nextPage,
                    child: Center(
                      child: LoadingScreen(
                        visible: userProvider.nextPage,
                      ),
                    ),
                  ),
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: userProvider.NO_ACCOUNT && !userProvider.nextPage,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            "Добавьте транспортное средство",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: width * 0.1,
                              fontFamily: "Montserrat",
                              color: Color.fromRGBO(66, 66, 74, 1),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_downward_sharp,
                          size: width * 0.3,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !userProvider.nextPage,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: width * 0.05, horizontal: width * 0.03),
                      child: Visibility(
                        visible: !userProvider.NO_ACCOUNT,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AbovePartOfAccount(
                                width: width,
                              ),
                              Adds(),
                              SizedBox(
                                height: width * 0.04,
                              ),
                              Expanded(child: ListOfIndicator(
                                onLoad: onload,
                                height: width * 1.05,
                                getIndicators: getIndicators,
                              )),
                              SizedBox(
                                height: width * 0.1,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Visibility(
                visible: !userProvider.nextPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    if (userProvider.NO_ACCOUNT) {
                      userProvider.setNextPage(true);
                      userProvider.setClearSettings(true);
                      SingletonRegistrationAuto().clean();
                      final items = http.get('${SingletonConnection.URL}/marka/');
                      items.then((value) async {
                        jsonDecode(value.body).forEach(
                            (e) => SingletonRegistrationAuto().fromJson(e));
                        SingletonRegistrationAuto().finish();

                        final results = await Navigator.of(context).pushNamed(
                            "/registration_auto",
                            arguments: MenuPOP.NO_ACCOUNT);
                        if (results == true) {
                          print("HERE COOL");
                          userProvider.setNO_ACCOUNT(false);

                          userProvider.updateData(
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
                          userProvider.setClearMenu(false);
                          userProvider.setIndicators([]);
                          userProvider.setLoading(true);
                          SingletonUserInformation()
                              .cards
                              .loadCards()
                              .then((value) {
                            print(SingletonUserInformation().indicators());
                            userProvider.setIndicators(
                                SingletonUserInformation().indicators());
                            userProvider.setAverageRun(
                                SingletonUserInformation().average);
                            userProvider.setChanged(true);
                            userProvider.setLoading(false);
                          });
                        }
                        userProvider.setNextPage(false);
                      });
                    } else {
                      addCard(context);
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/add.svg",
                    height: width * 0.13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void addCard(context) {
    final result = Navigator.of(context).pushNamed("/create_cards");
    result.then((value) {
      if (value != null) {
        userProvider.setRun(SingletonUserInformation().run);
        SingletonUserInformation().averageRun();
        userProvider.setAverageRun(SingletonUserInformation().average);
        userProvider.setLoading(true);
        SingletonConnection().createCards().then((value) {
          SingletonUserInformation()
              .newCard
              .change
              .setInitialRun(SingletonUserInformation().run);
          SingletonUserInformation().newCard.attach.setImage(
              SingletonUserInformation().newCard.attach.uploadedImage);
          SingletonUserInformation().newCard.attach.clean();
          SingletonUserInformation()
              .cards
              .card
              .add(SingletonUserInformation().newCard);
          userProvider.setIndicators(SingletonUserInformation().indicators());
          SingletonUserInformation().newCardClean();
          userProvider.setChanged(true);
        });
      } else {
        SingletonUserInformation().newCardClean();
      }
    });
  }
}
