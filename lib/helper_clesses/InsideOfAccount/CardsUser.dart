import 'dart:io';


import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_projects/Provider/CheckProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonGetX.dart';
import 'package:flutter_projects/controller/controller_cards.dart';
import 'package:get/get.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/DropDown/DropDownItem.dart';
import 'package:flutter_projects/helper_clesses/TextInput/TextFieldHelper.dart';
import 'package:flutter_projects/models/visibility.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../AnimatedContainerBorder.dart';
import '../Buttons.dart';
import '../TextFlexible.dart';
import 'CardsImages.dart';
import 'MainMenu.dart';

class CardsUser extends StatefulWidget {
  final ErrorMessageProvider provider;
  final ErrorMessageProvider runProvider;
  final ErrorMessageProvider commentsProvider;
  final Function recommendationFunction;
  final Function readyButton;
  final String nameButton;
  final List childAboveButton;
  final Widget middleChild;
  final CheckProvider checkProvider;
  final Widget secondChild;
  final String appBarName;
  final Widget checkWidget;
  final ErrorMessageProvider dateProvider;
  CardsUser(
      {Key key,
      this.provider,
      this.commentsProvider,
      this.runProvider,
      this.recommendationFunction,
      this.readyButton,
      this.nameButton,
      this.childAboveButton,
      this.middleChild,
      this.secondChild,
      this.appBarName,
      this.dateProvider,
      this.checkProvider,
      this.checkWidget})
      : super(key: key);

  @override
  _CardsUserState createState() => _CardsUserState(
        provider: provider,
        runProvider: runProvider,
        commentsProvider: commentsProvider,
        recommendationFunction: recommendationFunction,
        readyButton: readyButton,
        nameButton: nameButton,
        secondChild: secondChild,
        middleChild: middleChild,
        appBarName: appBarName,
        childAboveButton: childAboveButton,
        dateProvider:dateProvider,
    checkProvider:checkProvider,
      );
}

class _CardsUserState extends State<CardsUser> {
  final ErrorMessageProvider provider;

  final ErrorMessageProvider runProvider;
  final ErrorMessageProvider commentsProvider;
  final Function recommendationFunction;
  final Function readyButton;
  final String nameButton;
  final List childAboveButton;
  final Widget middleChild;
  final Widget secondChild;
  final String appBarName;
  final ErrorMessageProvider dateProvider;
  final CheckProvider checkProvider;
  final Widget checkWidget;
  final f = new DateFormat.yMd().add_Hm();
  String name;
  List<Widget> imagesChosen = [];
  Widget swap;
  String chosenDate= "";
  int visibility = 0;

  _CardsUserState({
    this.provider,
    this.commentsProvider,
    this.runProvider,
    this.recommendationFunction,
    this.readyButton,
    this.nameButton,
    this.childAboveButton,
    this.middleChild,
    this.secondChild,
    this.appBarName,
    this.dateProvider,
    this.checkProvider,
    this.checkWidget
  });
  final _picker = ImagePicker();
  _imgFromGallery(double width) async {
    PickedFile image = await _picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (image != null) {
        SingletonUserInformation().newCard.attach.updatedImage.add(image.path);
        setState(() {
          imagesChosen.add(CardsImages(
            key: UniqueKey(),
            path: image.path,
            delete:(int id){
              SingletonUserInformation().newCard.attach.updatedImage.remove(image.path);
              SingletonUserInformation().newCard.attach.uploadedImage.remove(id);
            },
            child: Image.file(
              File(image.path),
              fit:BoxFit.fill,
            ),
          ));
        });
      }
    });
  }
  void deleteImage(Widget, String path){

  }
  _imgFromCamera(double width) async {
    PickedFile image = await _picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (image != null) {
        SingletonUserInformation().newCard.attach.updatedImage.add(image.path);
        setState(() {
          imagesChosen.add(CardsImages(
            path: image.path,
            delete:(int id){
              SingletonUserInformation().newCard.attach.updatedImage.remove(image.path);
              SingletonUserInformation().newCard.attach.uploadedImage.remove(id);
            },
            child: Image.file(
              File(image.path),
              fit:BoxFit.fill,
            ),
          ));
        });
      }
    });
  }
  Widget swapToDrop(double width) {
    return DropDownItem(
      items: SingletonRecomendation().choicesCreateCard(),
      width: width,
      enabledHeight: width * 0.35,
      disabledHeight: width * 0.1,
      iconsAddition: rowIcons(width),
    );
  }

  Widget swapToText(double width) {
    return TextFieldHelper(
      suffixIcon: SizedBox(width: width * 0.165, child: rowIcons(width)),
    );
  }

  Widget textStart(double width) {
    swap = AnimatedContainerBorder(
      duration: 600,
      child: Container(
        margin: EdgeInsets.all(width*0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(provider.inputData,
          style: TextStyle(
              color: HexColor("#42424A"),
              fontFamily: "Roboto",
              fontSize: width * 0.03),
            ),
            pencil(width),
          ],
        ),
      ),
    );
    return  swap;
  }

  Widget pencil(double width) {
    return GestureDetector(
      onTap: () {
        if (visibility!=1)
        {

          setState(() {
            provider.setNameOfHelper("Введите название");
            provider.setInputData("");
            visibility = 1;
            swap = swapToText(width);
          });
        }
      },
      child: SvgPicture.asset(
        'assets/pencil.svg',
      ),
    );
  }

  Widget arrow(double width) {
    return GestureDetector(
      onTap: () {
        if (visibility != 2) {

          setState(() {
            provider.setNameOfHelper("Выберите название");
            provider.setInputData("");
            visibility = 2;
            swap = swapToDrop(width);
          });
        }
      },
      child: SvgPicture.asset('assets/arrow_down.svg'),
    );
  }

  Widget Dates(double width, Widget child) {
    return AnimatedContainerBorder(
      duration: 100,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.03),
        height: sizeGeneral(width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child,
            Text(
              chosenDate,
              style: TextStyle(
                  color: HexColor("#42424A"),
                  fontFamily: "Roboto",
                  fontSize: width * 0.03),
            )
          ],
        ),
      ),
    );
  }

  Widget rowIcons(double width) {
    return Row(
      children: [
        pencil(width),
        SizedBox(
          width: width * 0.05,
        ),
        arrow(width),
      ],
    );
  }

  double sizeGeneral(double width) {
    return width * 0.12;
  }

  Widget marginHeight(double width) {
    return SizedBox(
      height: width * 0.025,
    );
  }

  Widget marginWidth(double width) {
    return SizedBox(
      width: width * 0.01,
    );
  }
  Widget imagesAttach(double width){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:imagesChosen,
      ),
    );
  }
  Widget rowSvgText(String svg, String text, double width) {
    return Row(
      children: [
        SvgPicture.asset(
          svg,
          width: sizeSvg(width),
        ),
        marginWidth(width),
        marginWidth(width),
        marginWidth(width),
        Text(
          text,
          style: TextStyle(
            color: HexColor("#42424A"),
            fontFamily: 'Montserrat',
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double sizeSvg(double width) {
    return width * 0.05;
  }

  @override
  void initState() {

    super.initState();
    SingletonConnection().cleanTemp();

   chosenDate = f.format(DateTime.now());
   dateProvider.setInputData(DateTime.now().toString());
   List image = SingletonUserInformation().newCard.attach.image;
   if (image.isNotEmpty)
    image.forEach((element) {
      imagesChosen.add(CardsImages(
        unique: element,
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return  MainMenu(
      visible: VisibilityClass(
        filterVisible: false,
        menuVisible: true,
      ),
      nameBar: TextFlexible(
        text: appBarName,
        numberOfCharacters: 25,
      ),
      body: Container(
        margin: EdgeInsets.only(top: width * 0.05),
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                secondChild != null
                    ? Column(
                        children: [
                          swap != null
                              ? swap
                              : textStart(width),
                          marginHeight(width),
                          secondChild,
                        ],
                      )
                    : swap != null
                        ? swap
                        : swapToDrop(width),
                marginHeight(width),
                Consumer<ErrorMessageProvider>(
                    builder: (context, provider, child) {
                      // _.setName(SingletonGetX().nameOfCards.value);
                   return Buttons(
                      hexValueOFColor: "#32BEA6",
                      width: width,
                      nameOfTheButton: "Рекомендации по ${SingletonRecomendation()
                          .chosenRecommend(provider.inputData)
                          ?.mainName ??
                          "сервису"}  для ${SingletonUserInformation()
                          .marka} ${SingletonUserInformation().model}",
                      height: width * 1.2,
                      onPressed: recommendationFunction,
                    );
                  }
                ),
                marginHeight(width),
                marginHeight(width),
               dateProvider==null?SizedBox():ChangeNotifierProvider.value(
                  value: dateProvider,
                  child: GestureDetector(
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        setState(() {
                          dateProvider.setInputData(date.toString());
                          chosenDate = f.format(date);
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                    child: Dates(
                        width,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/calendar.svg',
                              width: width * 0.05,
                            ),
                            marginWidth(width),
                            Text(
                              "${dateProvider.nameOfHelper}",
                                  style: TextStyle(
                                    color: HexColor("#42424A"),
                                    fontFamily: 'Montserrat',
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        )),
                  ),
                ),
                marginHeight(width),
                ChangeNotifierProvider.value(
                  value: runProvider,
                  child: TextFieldHelper(
                    onlyInteger: true,
                    prefixIcon: Container(
                      margin: EdgeInsets.only(left: width * 0.03),
                      width: width * 0.1,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/car.svg',
                            width: width * 0.07,
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: SizedBox(
                        height: width * 0.1,
                        child: Container(
                          margin: EdgeInsets.only(right: width * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${SingletonUserInformation().run} ${SingletonUnits().distance}",
                                  style: TextStyle(
                                    color: HexColor("#42424A"),
                                    fontFamily: 'Roboto',
                                    fontSize: width * 0.035,
                                  ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                marginHeight(width),
                middleChild != null
                    ? Column(children: [
                        middleChild,
                        marginHeight(width),
                      ])
                    : marginHeight(width),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rowSvgText("assets/clip.svg", "Прикрепить", width),
                    Row(
                      children: [
                        GestureDetector(
                         onTap: ()=> _imgFromGallery(width),
                          child: SvgPicture.asset(
                            'assets/gallery.svg',
                            width: sizeSvg(width),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        GestureDetector(
                          onTap: () => _imgFromCamera(width),
                          child: SvgPicture.asset(
                            'assets/camera.svg',
                            width: sizeSvg(width),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        GestureDetector(
                          onTap: (){ Navigator.of(context).pushNamed("/location");},
                          child: SvgPicture.asset(
                            'assets/location.svg',
                            width: width * 0.03,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                marginHeight(width),
                imagesAttach(width),
                marginHeight(width),
                marginHeight(width),
                SizedBox(
                  height: width * 0.1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        rowSvgText(
                            "assets/speech_bubble.svg", "Комментарии", width),
                        marginWidth(width),
                        marginWidth(width),
                        marginWidth(width),
                        Expanded(
                          child: SizedBox(
                              width: width * 0.5,
                              child: ChangeNotifierProvider.value(
                                  value: commentsProvider,
                                  child: TextFieldHelper())),
                        )
                      ]),
                ),
                childAboveButton != null
                    ? Column(children: [
                        marginHeight(width),
                        marginHeight(width),
                        marginHeight(width),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            rowSvgText(childAboveButton[0],
                                childAboveButton[1], width),
                            marginWidth(width),
                            marginWidth(width),
                            marginWidth(width),
                            childAboveButton[2](context),
                          ],
                        )
                      ])
                    : marginHeight(width),
                marginHeight(width),
                Center(
                  child: SizedBox(
                    width: width * 0.42,
                    child: Buttons(
                      hexValueOFColor: "#7FA5C9",
                      nameOfTheButton: nameButton,
                      height: width,
                      onPressed: readyButton
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
