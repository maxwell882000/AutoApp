import 'package:flutter/material.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/Indicator.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/ListOfInicator.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/MainMenu.dart';
import 'package:flutter_projects/helper_clesses/TextFlexible.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_projects/pages/Inside/User.dart';
import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {

  const History({Key key}) : super(key: key);

  Future<List<Widget>> onLoad() async {
    await SingletonUserInformation().cards.loadStoreCards();
    List<Widget> allIndicators = [];
    List indicators = SingletonUserInformation().indicatorsStore();
    print("SADASDASD");
    print(indicators);
    if (indicators.isNotEmpty) {
      allIndicators = indicators.map<Widget>((e) => getIndicators(e)).toList();
      return allIndicators;
    }
    return [];
  }
  Widget getIndicators(List indicator) {
    print(indicator[4]);
    return Indicator(
        key: UniqueKey(),
        textOfIndicator: indicator[0],
        dataPercent: indicator[1],
        dataTime: indicator[2],
        dataDistance: indicator[3],
        id: indicator[4]
    );
  }

  @override
  Widget build(BuildContext context) {

      return MainMenu(
        visible: new VisibilityClass(
          filterVisible: false,
          menuVisible: true,
          settingsCross: false,
          clearMenu: false,
        ),
        nameBar: TextFlexible(
          text: "История".tr,
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, child) => Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width*0.05, vertical: Get.height*0.03),
            child: ListOfIndicator(
              height: Get.height,
              getIndicators: getIndicators,
              onLoad: () async {
                  List<Widget> result =  await onLoad();
                  provider.setLoading(false);
                  return result;
              },
            ),
          ),
        ),
      );
  }
}
