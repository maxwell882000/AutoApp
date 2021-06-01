import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_projects/Provider/CheckProvider.dart';

import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonGlobal.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonRegistrationAuto.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Dialog/CustomDialog.dart';
import 'package:flutter_projects/helper_clesses/Dialog/DialogSaved.dart';
import 'package:flutter_projects/helper_clesses/DropDown/ListOfDropDownItemWithText.dart';
import 'package:flutter_projects/helper_clesses/InsideOfAccount/get_x_widgets/controller/controllers.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../Buttons.dart';
import '../../LoadingScreen.dart';

import '../ExportExcel.dart';

class AppBarForAccount extends GetView<AppBarController>
    implements PreferredSizeWidget {
  final Widget nameBar;
  final VisibilityClass visible;

  AppBarForAccount({
    this.nameBar,
    this.visible
  });
  final CheckProvider check = new CheckProvider();
  final List filters = [
    'БЛИЖАЙШАЯ ЗАМЕНА / РЕМОНТ',
    'НЕДАВНО ДОБАВЛЕННЫЕ',
    'ВРУЧНУЮ ДОБАВЛЕННЫЕ'
  ];
  final List setting = [
    [
      'ИМПОРТ / ЭКСПОРТ ДАННЫХ В EXCEL',
      (context) {
        ExportExcel export = new ExportExcel();
        Future path = export.export();
        path.then((value) {
          showDialog(
              context: context,
              builder: (context) => DialogSaved(
                    text: value,
                  ));
        });
      }
    ],
    [
      'ПЕРЕДАТЬ ДАННЫЕ ДРУГОМУ',
      (context) {
        final double width = MediaQuery.of(context).size.width;
        final result = CustomDialog.dialog(
            width: width,
            context: context,
            barrierDismissible: false,
            child:
                WillPopScope(onWillPop: () async => false, child: ShareData()));
        result.then((value) {
          Navigator.of(context).pop(value);
        });
      }
    ],
    [
      'ТРЕКИНГ ПОЕЗДОК',
      (context) {
        Navigator.popAndPushNamed(context, "/map");
      }
    ],
    ['ИСТОРИЯ АВТО', (context) {}],
    [
      'ПОЛУЧИТЬ PRO ДОСТУП',
      (context) {
        Navigator.popAndPushNamed(context, "/pro_account");
      },
      HexColor("#DF5867")
    ],
  ];





  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void update() {
    final provider = Provider.of<UserProvider>(Get.context, listen: false);
    provider.updateData(
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
    provider.setIndicators([]);
    provider.setLoading(true);
    SingletonUserInformation().cards.loadCards().then((value) {
      provider.setIndicators(SingletonUserInformation().indicators());
      provider.setAverageRun(SingletonUserInformation().average);
      provider.setChanged(true);

      provider.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<UserProvider>(context);

    return AppBar(
      backgroundColor: Colors.white,
      leading: Visibility(
        visible: !provider.clearMenu,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: IconButton(
          //CAMERA
          onPressed: () {
            if (visible.menuVisible) {
              final response = Navigator.of(context).pushNamed("/menu");
              response.then((value) {
                if (value == MenuPOP.CHANGE_TRANSPORT) {
                  update();
                }
              });
            } else {
              Navigator.of(context).pop(MenuPOP.POP);
            }
          },
          icon: Icon(
            visible.menuVisible ? Icons.menu : Icons.clear,
            size: width * 0.1,
          ),
          color: Color.fromRGBO(66, 66, 74, 1),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          nameBar,
          Flexible(
            child: Text(""),
          ),
        ],
      ),
      toolbarHeight: width * 0.15,
      centerTitle: true,
      actions: <Widget>[
        Visibility(
          visible: !provider.clearSettings,
          child: GestureDetector(
            onTap: () {
              if (visible.settingsCross == null) {
                controller.settings.value = true;
                final result = CustomDialog.dialog(
                    width: width,
                    context: context,
                    child: SizedBox(
                      height: width * 0.55,
                      child: ListView.builder(
                        itemBuilder: (context, position) => Settings(
                          pop: setting[position][1],
                          text: setting[position][0],
                          color: setting[position].length >= 3
                              ? setting[position][2]
                              : null,
                        ),
                        itemCount: setting.length,
                      ),
                    ));
                result.then((value) {
                  controller.settings.value = false;
                  if (value == Requests.SUCCESSFULLY_CREATED) {
                    SingletonRecomendation().clean();
                    SingletonRegistrationAuto().clean();
                    provider.setNextPage(true);
                    SingletonConnection().authorizedData().then((value) {
                      provider.setNextPage(false);
                      update();
                    });
                  } else if (value == Requests.BAD_REQUEST) {
                    SingletonUserInformation().clean();
                    provider.setNO_ACCOUNT(true);
                    provider.setClearMenu(true);
                  }
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: Obx(
              () => SvgPicture.asset(
                controller.settings.value
                    ? "assets/cross.svg"
                    : "assets/CogWheelt.svg",
                height: width * 0.07,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.05,
        ),
        Visibility(
          visible: visible.filterVisible,
          child: GestureDetector(
            onTap: () {
              controller.filter.value = true;
              final result = CustomDialog.dialog(
                width: width,
                child: SizedBox(
                  height: width * 0.5,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      check.items.add(new CheckProvider());
                      return ChangeNotifierProvider.value(
                          value: check.items.last,
                          child: Filtering(
                            id: position,
                            name: filters[position],
                            check: check,
                          ));
                    },
                    itemCount: filters.length,
                  ),
                ),
                context: context,
              );
              result.then((value) {
                controller.filter.value = false;
                if (value != null) {
                  switch (value) {
                    case 0:
                      provider.setSortChange(true);
                      break;
                    case 1:
                      provider.setSortRecent(true);
                      break;
                    case 2:
                      provider.setSortOfUser(true);
                      break;
                  }
                }
                check.clean();
              });
            },
            child: Obx(
              () => SvgPicture.asset(
                controller.filter.value
                    ? "assets/cross.svg"
                    : "assets/funel.svg",
                height: width * 0.07,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class _AppBarForAccountState extends State<AppBarForAccount> {
//   final Widget nameBar;
//   final bool filterVisible;
//   final bool menuVisible;
//   final bool settingsCross;
//
//   _AppBarForAccountState({
//     this.nameBar,
//     this.menuVisible,
//     this.filterVisible,
//     this.settingsCross,
//   });
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   if (settingsCross != null) {
//   //     settings = settingsCross;
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {}
// }

class Settings extends StatelessWidget {
  final Function pop;
  final String text;
  final Color color;

  Settings({Key key, this.pop, this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      child: TextButton(
        onPressed: () => pop(context),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: color != null ? color : HexColor("#42424A"),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: width * 0.03,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class Filtering extends StatelessWidget {
  final String name;
  final int id;
  final CheckProvider check;

  Filtering({Key key, this.name, this.id, this.check}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<CheckProvider>(context);
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              check.clicked(id);
              Navigator.of(context).pop(id);
            },
            child: SvgPicture.asset(
              provider.checked ? "assets/checked.svg" : "assets/unchecked.svg",
              height: width * 0.05,
            ),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          Text(
            name,
            style: TextStyle(
                color: HexColor("#42424A"),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: width * 0.03,
                decoration: TextDecoration.none),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.05),
    );
  }
}

class ShareData extends StatefulWidget {
  @override
  _ShareDataState createState() => _ShareDataState();
}

class _ShareDataState extends State<ShareData> {
  final ErrorMessageProvider selectOptionsErrorProvider =
      new ErrorMessageProvider("");
  bool loading = true;
  final List accounts = [];
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Widget list = SizedBox();

  @override
  void initState() {
    super.initState();
    selectOptionsErrorProvider.setNextPage(true);
    SingletonConnection().getTransports().then((value) {
      List items = [
        [1, "Аккаунт передачи", "Телефон или mail", 0],
      ];
      List names = [0, "Транспорт", "Выберите Транспорт"];
      setState(() {
        value.forEach((element) {
          accounts.add([element['nameOfTransport'], element['id']]);
          names.add(element['nameOfTransport']);
        });
        items.add(names);
        selectOptionsErrorProvider.setItems(items);
        loading = false;
        selectOptionsErrorProvider.setNextPage(false);
        double width = MediaQuery.of(context).size.width;
        list = ListOfDropDownItemWithText(
          itemWithTextField: items,
          disabledHeightOfItem: width * 0.12,
          enabledHeightOfItem: width * 0.25,
          width: width,
          heightOfDropDownItems: width * 1.1,
          provider: selectOptionsErrorProvider,
        );
      });
    });
    // List items = [
    //   [1, "Аккаунт передачи", "Телефон или mail", 0],
    //   [0, "Транспорт", "Выберите год приобретения", "2000", "2010"],
    // ];
    // selectOptionsErrorProvider.setItems(items);
    // loading = false;
  }

  void share(BuildContext context) {
    final provider = Provider.of<ErrorMessageProvider>(context, listen: false);
    List errors = provider.errorsMessageWithText;
    var selected = errors
        .where((element) => !element[1].selected && element[0] != "ТЕХ ПАСПОРТ")
        .map((element) => errors.indexOf(element));
    Widget list;
    if (selected.length == 0) {
      selectOptionsErrorProvider.setNextPage(true);
      String id = "";
      accounts
          .where((element) => element[0] == errors[1][1].inputData)
          .forEach((e) => id = e[1].toString());
      SingletonConnection()
          .shareTransport(errors[0][1].inputData, id)
          .then((value) {
        if (Requests.NOT_FOUND == value) {
          selectOptionsErrorProvider.setNextPage(false);
          selectOptionsErrorProvider.errorsMessageWithText[0][1]
              .setNameOfHelper("Пользователь с таким данными не существует");
          selectOptionsErrorProvider.errorsMessageWithText[0][1].setError(true);
        } else if (Requests.NO_INTERNET == value) {
          selectOptionsErrorProvider.setNextPage(false);
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('У вас нет интернета!')),
          );
        } else {
          if (int.parse(id) != SingletonUserInformation().id) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop(value);
          }
        }
      });
    } else {
      selected.forEach((element) {
        var error = errors[element];

        error[1].setError(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: selectOptionsErrorProvider,
      child: Container(
        width: width * 0.8,
        height: width * 0.6,
        child: Scaffold(
          key: _globalKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(width * 0.2)),
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: width * 0.05),
            child: Builder(builder: (context) {
              final provider = Provider.of<ErrorMessageProvider>(context);
              return Stack(
                children: [
                  Center(
                    child: LoadingScreen(
                      visible: provider.nextPage,
                      color: "#F0F8FF",
                    ),
                  ),
                  Visibility(
                    visible: !provider.nextPage,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Column(
                      children: [
                        Expanded(child: list),
                        Row(
                          children: [
                            Expanded(
                              child: Buttons(
                                onPressed: (context) => share(context),
                                hexValueOFColor: "#7FA5C9",
                                nameOfTheButton: "Передать",
                                height: width * 0.8,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            Expanded(
                              child: Buttons(
                                onPressed: (context) =>
                                    Navigator.of(context).pop(),
                                hexValueOFColor: "#7FA5C9",
                                nameOfTheButton: "Назад",
                                height: width * 0.8,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// SizedBox(
// height: width*0.4,
// width: width*0.3,
// child: AlertDialog(
// actions: <Widget>[
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [

// ],
// ),
// ],
// ),
// );
