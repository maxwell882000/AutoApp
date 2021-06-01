
import 'package:flutter/cupertino.dart';

import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/TextInput/TextFieldHelper.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CardStatic{
   static Function choiceWidget(double width, ErrorMessageProvider repeatDistProvider, ErrorMessageProvider repeatTimeProvider) {
    return (context) {
      final ErrorMessageProvider provider =
      Provider.of<ErrorMessageProvider>(context);

      final double run =
      SingletonRecomendation().recommendationProbeg(provider.inputData);

      if (run != null) {
        repeatDistProvider.setError(false);
        SingletonUserInformation()
            .newCard
            .change
            .setRun(run + SingletonUserInformation().run);
      }
      repeatDistProvider.setRecommendations(
        SizedBox(
            height: width * 0.1,
            child: Container(
              margin: EdgeInsets.only(right: width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    run == null ? "" : "$run ${SingletonUnits().distance}",
                    style: TextStyle(
                      color: HexColor("#42424A"),
                      fontFamily: 'Roboto',
                      fontSize: width * 0.035,
                    ),
                  ),
                ],
              ),
            )),
      );
      double average = SingletonUserInformation().average;
      int time;
      int days;

      if (run != null && average != 0) {
        time = run ~/ average;
        days =
            SingletonUnits().translateTimeToDays(SingletonUnits().time, time);
      }
      print("RUN $run");
      print("Days $days");
      repeatTimeProvider.setRecommendations(
        SizedBox(
            height: width * 0.1,
            child: Container(
              margin: EdgeInsets.only(right: width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    run == null
                        ? ""
                        : days != null
                        ? "$days ${SingletonUnits().convertDaysToString(days)}"
                        : "",
                    style: TextStyle(
                      color: HexColor("#42424A"),
                      fontFamily: 'Roboto',
                      fontSize: width * 0.035,
                    ),
                  ),
                ],
              ),
            )),
      );

      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangeNotifierProvider.value(
              value: repeatDistProvider,
              child: TextFieldHelper(
                onlyInteger: true,
              ),
            ),
            SizedBox(
              height: width * 0.02,
            ),
            Text("Или"),
            SizedBox(
              height: width * 0.02,
            ),
            ChangeNotifierProvider.value(
              value: repeatTimeProvider,
              child: TextFieldHelper(
                onlyInteger: true,
              ),
            ),
          ],
        ),
      );
    };
  }
    }