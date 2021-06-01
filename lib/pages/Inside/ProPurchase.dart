import 'package:flutter/material.dart';

import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/helper_clesses/Dialog/CustomDialog.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/MainMenu.dart';
import 'package:flutter_projects/helper_clesses/Payme/payme_pay.dart';
import 'package:flutter_projects/helper_clesses/TextFlexible.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class ProPurchase extends StatelessWidget {
  final List items = [
    "ВОЗМОЖНОСТЬ ДОБАВИТЬ БОЛЬШЕ 1 АВТО В ПРОФИЛЬ".tr,
    "Возможность отслеживать и добавлять неограниченное количество авто деталей (в бесплатном можно отслеживать 10 и добавить 5)",
    "НЕТ РЕКЛАМЫ",
  ];
  final List icons = [
    ['assets/paynet.png', () {}],
    ['assets/click.png', () {

    }],
    ['assets/payme.png', () {
    CustomDialog.dialog(
      barrierDismissible: false,
      context: Get.context,
      width: Get.width,

      child: PaymePay(),
      alignment: Alignment.center
    );
    }],
  ];

  Widget text({Color color, String text, double width}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Montserrat",
        fontSize: width * 0.028,
        color: HexColor("#42424A"),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget choices({String text, double width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/tick.svg",
          width: width * 0.05,
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Flexible(child: this.text(text: text, width: width))
      ],
    );
  }

  Widget iconsGet({String icons, double width, onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(right: width * 0.03),
        width: width * 0.24,
        child: Image.asset(
          icons,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserProvider(),
      child: MainMenu(
        visible: VisibilityClass(
          filterVisible: false,
          settingsCross: true,
        ),
        nameBar: TextFlexible(
          key: key,
          text: "Получить про доступ",
          numberOfCharacters: 25,
        ),
        body: Container(
          margin: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.06),
                height: width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(text: "PRO ДОСТУП ВКЛЮЧАЕТ В СЕБЯ:", width: width),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    SizedBox(
                      height: width * 0.35,
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, position) =>
                              choices(text: items[position], width: width),
                          separatorBuilder: (context, position) => SizedBox(
                                height: width * 0.05,
                              ),
                          itemCount: items.length),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.1,
              ),
              Container(
                padding: EdgeInsets.all(width * 0.06),
                height: width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text(text: "PRO ДОСТУП ВКЛЮЧАЕТ В СЕБЯ:", width: width),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    SizedBox(
                      height: width * 0.1,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, position) =>
                              iconsGet(
                                  icons: icons[position][0],
                                  width: width,
                                  onTap: icons[position][1]
                              ),
                          separatorBuilder: (context, position) => SizedBox(
                                width: width * 0.01,
                              ),
                          itemCount: icons.length),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
