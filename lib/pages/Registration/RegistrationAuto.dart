import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonGlobal.dart';
import 'package:flutter_projects/Singleton/SingletonRegistrationAuto.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/DataNotSave.dart';
import 'package:flutter_projects/helper_clesses/DropDown/ListOfDropDownItemWithText.dart';
import 'package:flutter_projects/helper_clesses/SelectOptions.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
class RegistrationAuto extends StatelessWidget {
  RegistrationAuto({Key key}) : super(key: key);
  final ErrorMessageProvider selectOptionsErrorProvider =
      new ErrorMessageProvider("");

  Function readyToTheNext(Function loadToHard) {
    return (BuildContext context) {
      var errors = selectOptionsErrorProvider.errorsMessageWithText;
      var selected = errors
          .where(
              (element) => !element[1].selected && element[0] != "ТЕХ ПАСПОРТ".tr)
          .map((element) => errors.indexOf(element)).toList();
      print(selected);
      if (selected.length == 0) {
        // selectOptionsErrorProvider.setNextPage(true);
        loadToHard(errors);
      } else {
        selected.forEach((element) {
          var error = errors[element];
          print(error);
          error[1].setError(true);
        });
      }
    };
  }

  Function getInformationCar(BuildContext context, MenuPOP args) {
    return (var errors) {
      print(errors);
      errors.forEach((element) {
        print("${element[0]} \t ${element[1].inputData}");
      });
      SingletonUserInformation().setNameOfTransport(errors[0][1].inputData);
      SingletonUserInformation().setMarka(errors[1][1].inputData);
      SingletonUserInformation().setModel(errors[2][1].inputData);
      SingletonUserInformation().setYearOfMade(errors[3][1].inputData);
      SingletonUserInformation().setYearOfPurchase(errors[4][1].inputData);
      SingletonUserInformation().setNumber(errors[5][1].inputData);
      SingletonUserInformation().setRun(double.parse(errors[6][1].inputData));
      SingletonUserInformation().setTechPassport(errors[7][1].inputData);
      SingletonUserInformation()
          .setNumberOfTank(int.parse(errors[8][1].inputData));
      SingletonUserInformation().setFirstTankType(errors[9][1].inputData);
      SingletonUserInformation()
          .setFirstTankVolume(int.parse(errors[10][1].inputData));
      SingletonUserInformation().setInitialRun(SingletonUserInformation().run);
      print("Run ${SingletonUserInformation().run}");
      print(
          "Run after ${SingletonUnits().convertDistanceForDB(SingletonUserInformation().run)}");
      if (SingletonUserInformation().numberOfTank == 2) {
        SingletonUserInformation().setSecondTankType(errors[11][1].inputData);
        SingletonUserInformation()
            .setSecondTankVolume(int.parse(errors[12][1].inputData));
      } else {
        SingletonUserInformation().setSecondTankType("");
        SingletonUserInformation().setSecondTankVolume(0);
      }
      SingletonUserInformation().setDate(DateTime.now());
      //SingletonUserInformation().setToTheDisk();
      final response = SingletonConnection().registerCar();
      selectOptionsErrorProvider.setNextPage(true);
      response.then((value) {
        print("REGISTER CAR");
        print(value.body);
        Map json = jsonDecode(value.body);
        if (value) {
          print(json['id']);
          SingletonUserInformation().setId(json['id']);
          bool pop;
          if (args == MenuPOP.NEW_TRANSPORT) {
            SingletonUserInformation().cards.clean();
            pop = true;
            Navigator.of(context).popAndPushNamed("/authorized",result: pop);
            return;
          }
          SingletonRegistrationAuto().clean();
          if (args == MenuPOP.NO_ACCOUNT) {
            Navigator.of(context).pop(true);
            return;
          }
          SingletonConnection().recommendData().then((value) {
            Navigator.of(context).popAndPushNamed("/authorized");
          });
        } else {
          errors[0][1].setNameOfHelper(json['error']);
          errors[0][1].setError(true);
          selectOptionsErrorProvider.setNextPage(false);
        }
      });
    };
  }

  Function _onWillPop(BuildContext context) {
    return () async {
      final bool response = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DataNotSave());
      if (response) {
        SingletonRegistrationAuto().clean();
        SingletonConnection().deleteUser();
      }
      return response;
    };
  }

  @override
  Widget build(BuildContext context) {
    selectOptionsErrorProvider.setItems(SingletonRegistrationAuto().item);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double additional = 0.8;
    if (height> 850){
      additional +=0.4;
    }
    final MenuPOP args = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: args != MenuPOP.NEW_TRANSPORT && args != MenuPOP.NO_ACCOUNT
          ? _onWillPop(context)
          : () async => await true,
      child: ChangeNotifierProvider.value(
        value: selectOptionsErrorProvider,
        child: SelectOptions(
          icon: "assets/carfront.svg",
          aboveText: "Регистрация Транспортного Средства",
          width: width,
          height: height*0.9,
          clickEvent: readyToTheNext,
          loadToHard: getInformationCar(context, args),
          child: ListOfDropDownItemWithText(
            itemWithTextField: selectOptionsErrorProvider.items,
            disabledHeightOfItem: width*0.11,
            enabledHeightOfItem: width*0.25,
            width: width,
            heightOfDropDownItems: width * additional,
            provider: selectOptionsErrorProvider,
          ),
          widthOfButton: width * 0.2,
          heightOfButton: width * 0.024,
        ),
      ),
    );
  }
}
