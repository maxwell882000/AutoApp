import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_projects/Provider/CheckProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';
import 'package:flutter_projects/helper_clesses/InitialPointOfAccount/BackGroundMoving.dart';
import 'package:flutter_projects/helper_clesses/InitialPointOfAccount/CheckAgreement.dart';
import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LogInSelectingOption extends StatefulWidget {
  LogInSelectingOption({Key key}) : super(key: key);

  @override
  _LogInSelectingOptionState createState() => _LogInSelectingOptionState();
}

class _LogInSelectingOptionState extends State<LogInSelectingOption> {
  final String backGround = "assets/background.svg";
  final String car = "assets/car.svg";
  final double moveHorizontalBackGround = 0.1;

  final double moveHorizontalCar = -0.1;

  final String nameButtonFacebook = "Зарегестрироваться через Facebook";

  final String nameButtonGoogle = "Зарегестрироватьcя через Google";

  final String nameButtonUsual = "Заргестрироваться";

  final CheckProvider checkProvider = new CheckProvider();

  bool nextPage = false;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void checkTheAgreement() {
    checkProvider.setChecked(!checkProvider.checked);
  }

  Function launcher(Function _launch) {
    return (BuildContext context) {
      if (checkProvider.checked)
        _launch();
      else {
        Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text('Вы не согласились с условиями!')),
        );
      }
    };
  }

  Function login(Function _launch) {
    return (BuildContext context) {
      _launch();
    };
  }

  Future<void> _launchURLFacebook() async {
    const url = 'https://facebook.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch';
    }
  }

  Future<void> _launchURLGoogle() async {
    var url = '${SingletonConnection.URL}/loginGoogle/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch';
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      print("SADADAASSDASDASSADSADSADSAD ${deepLink} __");
      print(deepLink.queryParameters['emailOrPhone']);
      print(deepLink.path);
      if (deepLink != null) {
        List pathes = deepLink.path.split("/");
        pathes.removeWhere((element) => element == "" || element == null);
        String path = "/" + pathes[0];
        int id = int.parse(pathes[1]);
        SingletonUserInformation()
            .setEmailOrPhone(deepLink.queryParameters['emailOrPhone']);
        SingletonUserInformation()
            .setUserId(id);
        print("WATCH" + deepLink.path);
        print(path);
        if (path == "/select_unit"){
          final result  = Navigator.pushNamed(context, path);
        }
        else{
          setState(() {
            nextPage = true;
          });
          SingletonConnection().authorizedData().then((value) {
            setState(() {
              nextPage= false;
            });
            final  result = Navigator.pushNamed(context, path);
          });
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      SingletonUserInformation()
          .setEmailOrPhone(deepLink.queryParameters['emailOrPhone']);
      if (deepLink.path == "/select_unit") {
        final result = Navigator.pushNamed(context, deepLink.path);
      } else {
        setState(() {
          nextPage = true;
        });
        SingletonConnection().authorizedData().then((value) {
          setState(() {
            nextPage = false;
          });
          final result = Navigator.pushNamed(context, deepLink.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CheckProvider>.value(
      value: checkProvider,
      child: Scaffold(
        backgroundColor: HexColor("#F0F8FF"),
        body: nextPage
            ? Center(
                child: LoadingScreen(
                  visible: nextPage,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Center(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Auto ",
                              style: TextStyle(
                                letterSpacing: width * 0.01,
                                fontSize: width * 0.1,
                                fontFamily: "AdventPro",
                                fontWeight: FontWeight.bold,
                                color: HexColor("#3E7CA5"),
                              ),
                            ),
                            Text(
                              "App",
                              style: TextStyle(
                                letterSpacing: width * 0.01,
                                fontSize: width * 0.1,
                                fontFamily: "AdventPro",
                                fontWeight: FontWeight.bold,
                                color: HexColor("#DF5867"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.08,
                    ),
                    Container(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      height: width * 0.6,
                      width: width,
                      child: BackGroundMoving(
                        backGround: backGround,
                        object: car,
                        width: width,
                        height: height,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(width * 0.05),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Buttons(
                            icons: "assets/facebook.svg",
                            hexValueOFColor: "#3E7CA5",
                            height: width,
                            onPressed: launcher(_launchURLFacebook),
                            nameOfTheButton: nameButtonFacebook,
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          Buttons(
                            icons: "assets/google.svg",
                            hexValueOFColor: "#DF5867",
                            height: width,
                            onPressed: launcher(_launchURLGoogle),
                            nameOfTheButton: nameButtonGoogle,
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          Buttons(
                            hexValueOFColor: "#42424A",
                            height: width,
                            onPressed: launcher(() {
                              Navigator.of(context)
                                  .pushNamed("/select/registration");
                            }),
                            nameOfTheButton: nameButtonUsual,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    CheckAgreement(
                      width: width,
                      onTap: checkTheAgreement,
                    ),
                    SizedBox(
                      height: width * 0.1,
                    ),
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(width * 0.27, 0, width * 0.27, 0),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "Уже есть аккаунт?",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: width * 0.035,
                              color: HexColor("#42424A"),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.04,
                          ),
                          Buttons(
                            hexValueOFColor: "#7FA5C9",
                            height: width,
                            onPressed: login(() {
                              Navigator.of(context).pushNamed("/select/login");
                            }),
                            nameOfTheButton: "Войти сейчас",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
