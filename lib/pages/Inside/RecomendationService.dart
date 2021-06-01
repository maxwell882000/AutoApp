
import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/DropDown/ListDropDownInformation.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/MainMenu.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/Recomendation.dart';
import 'package:flutter_projects/helper_clesses/TextFlexible.dart';
import 'package:flutter_projects/models/visibility.dart';

class RecomendationService extends StatelessWidget {
  RecomendationService({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MainMenu(
      visible: VisibilityClass(
        filterVisible: false,
      ),

      nameBar: TextFlexible(
        key: key,
        text: "Рекомендации по сервису ${SingletonUserInformation().marka} ${SingletonUserInformation().model}",
        numberOfCharacters: 25,
      ),
      body: SingleChildScrollView(
        child: Recomendation(
          child:ListDropDownInformation(
            items: SingletonRecomendation().recommendationAll(),
          ) ,
        ),
      )
    );
  }
}