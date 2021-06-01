import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_projects/Pages/Inside/Map.dart';
import 'package:flutter_projects/dynamicLinks.dart';
import 'package:flutter_projects/helper_clesses/Payme/code_verification.dart';
import 'package:flutter_projects/helper_clesses/Payme/payme.dart';
import 'package:flutter_projects/helper_clesses/Payme/payme_pay.dart';
import 'package:flutter_projects/pages/Date.dart';
import 'package:flutter_projects/pages/Initial/DirectToThePage.dart';
import 'package:flutter_projects/pages/Initial/Language.dart';
import 'package:flutter_projects/pages/Initial/LogIn.dart';
import 'package:flutter_projects/pages/Initial/LogInSelectingOption.dart';
import 'package:flutter_projects/pages/Inside/Adds.dart';
import 'package:flutter_projects/pages/Inside/CreateCards.dart';
import 'package:flutter_projects/pages/Inside/Menu.dart';
import 'package:flutter_projects/pages/Inside/ModifyCards.dart';
import 'package:flutter_projects/pages/Inside/PointerLocation.dart';
import 'package:flutter_projects/pages/Inside/ProPurchase.dart';
import 'package:flutter_projects/pages/Inside/RecomendationService.dart';
import 'package:flutter_projects/pages/Inside/SingleRecomendation.dart';
import 'package:flutter_projects/pages/Inside/User.dart';
import 'package:flutter_projects/pages/Registration/Registration.dart';
import 'package:flutter_projects/pages/Registration/RegistrationAuto.dart';
import 'package:flutter_projects/pages/Registration/SelectUnit.dart';
import 'package:flutter_projects/pages/Test.dart';
import 'package:flutter_projects/service/translation_service.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Singleton/SingletonGlobal.dart';
import 'pages/Inside/History.dart';


void initServices() async {
  Get.log('starting services ...');
  await Get.putAsync(() => TranslationService().init());
  SingletonGlobal().setPrefs(await SharedPreferences.getInstance());
  Get.log('All services started...');
}


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(
            color: Color(0xFFF5F5F5),
          )),
      initialRoute: "/direct",

      localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: SingletonGlobal().locale,
      routes: <String, WidgetBuilder>{
        "/direct": (context) => DirectToThePage(),
        "/language": (context) => Language(),
        "/select/login": (context) => LogIn(),
        "/select": (context) => LogInSelectingOption(),
        "/select/registration": (context) => Registration(),
        "/select_unit": (context) => SelectUnit(),
        "/registration_auto": (context) => RegistrationAuto(),
        "/authorized": (context) => User(),
        "/create_cards": (context) => CreateCards(),
        "/modify_cards": (context) => ModifyCards(),
        "/recomendation_service": (context) => RecomendationService(),
        "/single_recomendation": (context) => SingleRecomendation(),
        "/dynamic": (context) => DynamicLinks(),
        "/menu": (context) => Menu(),
        "/location": (context) => PointerLocation(),
        "/pro_account": (context) => ProPurchase(),
        "/adds": (context) => Adds(),
        "/map": (context) => Map(),
        "/test": (context) => Test(),
        "/history": (context)=> History(),
        "/date": (context) => Date(),
        "/payme":(context) => PaymePay(),
        "/code-verification":(context) => CodeVerification()
      },
    );
  }
}
