
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/Provider/FeeProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Fee extends StatefulWidget {
  final int id;
  final String initName;
  final String initAmount;
  final String initSum;

  Fee({Key key, this.id, this.initAmount, this.initName, this.initSum})
      : super(key: key);

  @override
  _FeeState createState() =>
      _FeeState(
        id: id,
        initAmount: initAmount,
        initName: initName,
        initSum: initSum,
      );
}

class _FeeState extends State<Fee> {
  bool pressed = false;
  final String initName;
  final String initAmount;
  final String initSum;
  int id;

  _FeeState({this.id, this.initAmount, this.initSum, this.initName});

  TextEditingController nameController = TextEditingController();
  TextEditingController sumController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: initName);
    sumController = TextEditingController(text: initSum);
    amountController = TextEditingController(text: initAmount);
    if (id == null) {
      SingletonConnection().createExpense().then((value) {
        if (mounted) {
          final provider = Provider.of<FeeProvider>(context, listen: false);
          setState(() {
            id = value['id'];
            print("GET VALUE ALL VALUES GOTTED $id  $pressed");
            if (pressed) {
              print("GET VALUE AFTER DELETION $id");
              provider.setDelete(true);
              provider.setId(id);
              SingletonUserInformation().newCard.deletedExpense.add(id);
              SingletonUserInformation().newCard.uploadedExpense.remove(id);
              SingletonConnection().deleteExpense(id);
            }
            else {
              provider.setId(id);
              SingletonUserInformation().newCard.uploadedExpense.add(id);
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    sumController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void listener(FeeProvider provider) {
    nameController.addListener(() {
      provider.setName(nameController.text);
      if (nameController.text.isNotEmpty && provider.error) {
        provider.setError(false);
      }
    });
    sumController.addListener(() {
      provider.setSum(sumController.text);
      if (sumController.text.isNotEmpty && provider.error) {
        provider.setError(false);
      }
    });
    amountController.addListener(() {
      provider.setAmount(amountController.text);
    });
  }



  bool remove = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    var provider;
    if (mounted) {
      provider = Provider.of<FeeProvider>(context);
      listener(provider);
    }
    final node = FocusScope.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: pressed ? 0 : width * 0.15,
      margin: EdgeInsets.only(bottom: pressed ? 0 : width * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              provider.setDelete(true);
              if (!pressed) {
                print("Deleted $id");
                setState(() {
                  pressed = true;
                  remove = true;
                });
                sumController.clear();
                amountController.clear();
                nameController.clear();

                if (id != null) {
                  SingletonConnection().deleteExpense(id);
                  SingletonUserInformation().newCard.deletedExpense.add(id);
                  SingletonUserInformation().newCard.uploadedExpense.remove(id);

                }
              }
            },

            child: SvgPicture.asset(
              "assets/cross.svg",
              width: width * 0.05,
            ),
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Container(
            height: width * 0.15,
            decoration: BoxDecoration(
              color: provider.error ? HexColor("#7FA6C9") : HexColor("#C9CACE"),
              borderRadius: BorderRadius.circular(width * 0.02),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.01),
              width: width * 0.73,
              child: Visibility(
                visible: !remove,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: TextField(
                          showCursor: !pressed,
                          controller: nameController,
                          onEditingComplete: () => node.nextFocus(),
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: HexColor("#42424A"),
                            fontFamily: 'Montserrat',
                            fontSize: width * 0.03,
                          ),
                          decoration: new InputDecoration(
                            hintText: "Введите Название",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                          child: TextField(
                            showCursor: !pressed,
                            controller: sumController,
                            keyboardType: TextInputType.number,
                            onEditingComplete: () => node.nextFocus(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: HexColor("#42424A"),
                              fontFamily: 'Montserrat',
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: new InputDecoration(
                              hintText: "Введите Сумму",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                        Text(
                          "  " + " ${SingletonUnits().currency} " + " x ",
                          style: TextStyle(
                            color: HexColor("#42424A"),
                            fontFamily: 'Montserrat',
                            fontSize: width * 0.03,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                          child: TextField(
                            showCursor: !pressed,
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            onEditingComplete: () => node.nextFocus(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.black,
                            style: TextStyle(
                              color: HexColor("#42424A"),
                              fontFamily: 'Montserrat',
                              fontSize: width * 0.03,
                            ),
                            decoration: new InputDecoration(
                              hintText: "1",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
