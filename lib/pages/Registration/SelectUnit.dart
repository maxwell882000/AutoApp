import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonRegistrationAuto.dart';
import 'package:flutter_projects/Singleton/SingletonStoreUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/DataNotSave.dart';
import 'package:flutter_projects/helper_clesses/DropDown/ListOfDropDownItemWithText.dart';
import 'package:flutter_projects/helper_clesses/SelectOptions.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SelectUnit extends StatelessWidget {
  final List items = [
  ["Cкорость".tr,"Выберите скорость".tr ,SingletonStoreUnits().speed.KM_C,SingletonStoreUnits().speed.M_C,SingletonStoreUnits().speed.KM_H,SingletonStoreUnits().speed.M_H,SingletonStoreUnits().speed.KM_D,SingletonStoreUnits().speed.M_D,SingletonStoreUnits().speed.KM_Y,SingletonStoreUnits().speed.M_Y],
  ["Расстояние".tr, "Выберите растояние".tr,SingletonStoreUnits().distance.CM,SingletonStoreUnits().distance.KM,SingletonStoreUnits().distance.M,SingletonStoreUnits().distance.MM],
  ["Расход топлива".tr, "Выберите расход топлива".tr , SingletonStoreUnits().fuelConsumption.KM_L,SingletonStoreUnits().fuelConsumption.L_100KM,SingletonStoreUnits().fuelConsumption.L_KM],
  ["Валюта".tr,"Выберите валюту".tr ,  SingletonStoreUnits().currency.EUR,SingletonStoreUnits().currency.RUB,SingletonStoreUnits().currency.USD,SingletonStoreUnits().currency.UZS],
  ];


  SelectUnit({Key key}) : super(key: key);
  final ErrorMessageProvider selectOptionsErrorProvider =
  new ErrorMessageProvider("");

  Function readyToTheNext( Function loadToHard){
  return (BuildContext context) {
    var errors = selectOptionsErrorProvider.errorsMessageWithText;
    var selected = errors
        .where((element) => !element[1].selected)
        .map((element) => errors.indexOf(element));
    if (selected.length == 0) {
      selectOptionsErrorProvider.setNextPage(true);
      loadToHard(errors);
    } else {
      selected.forEach((element) {
        var error = errors[element];
        error[1].setError(true);
        error[1].setNameOfHelper("Здесь ничего не выбрано".tr);
      });
    }
  };
  }

  Function getUnits(BuildContext context) {
    return (var errorMessageProvider) async {
      SingletonUnits().setSpeed(errorMessageProvider[0][1].inputData);
      SingletonUnits().setDistance(errorMessageProvider[1][1].inputData);
      SingletonUnits().setFuelConsumption(errorMessageProvider[2][1].inputData);
      SingletonUnits().setCurrency(errorMessageProvider[3][1].inputData);
      SingletonUnits().setToTheDisk();
      print(SingletonUserInformation().emailOrPhone);
      http.put(
          '${SingletonConnection.URL}/units/${SingletonUserInformation().emailOrPhone}/',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body:jsonEncode(SingletonUnits().toJson()));
      final items = await http.get(
        '${SingletonConnection.URL}/marka/'
      );
      jsonDecode(items.body).forEach((e)=> SingletonRegistrationAuto().fromJson(e));
      SingletonRegistrationAuto().finish();
      Navigator.of(context).popAndPushNamed("/registration_auto");
    };
  }

  Function _onWillPop(BuildContext context)  {

    return  () async{

      final bool response = await showDialog(
          context: context,
        barrierDismissible: false,
        builder: (context) => DataNotSave()
      );
      print("SADADASDASDD");
      print(response);
      if(response){
        SingletonRegistrationAuto().clean();
        SingletonConnection().deleteUser();
      }
      return response;
    };
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop(context),
      child: ChangeNotifierProvider.value(
        value: selectOptionsErrorProvider,
        child: SelectOptions(
          key: UniqueKey(),
          width: width,
          height: width * 1.4,
          icon: "assets/unit.svg",
          aboveText: "Выбор единицы измерения".tr,
          child: ListOfDropDownItemWithText(
            item: items,
            disabledHeightOfItem: width*0.11,
            enabledHeightOfItem: width*0.25,
            width: width,
            heightOfDropDownItems: width*0.66,
            provider:selectOptionsErrorProvider,
          ),
          loadToHard: getUnits(context),
          clickEvent: readyToTheNext,
          widthOfButton: width * 0.2,
          heightOfButton: width * 0.013,
        ),
      ),
    );
  }
}

