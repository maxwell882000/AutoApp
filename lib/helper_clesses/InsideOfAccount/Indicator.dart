
import 'package:flutter/material.dart';
import 'package:flutter_projects/Pages/Inside/ModifyCards.dart';
import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonUnits.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Indicator extends StatefulWidget {
  final String textOfIndicator;
  final dataTime;
  final dataDistance;
  final double dataPercent;
  final int id;
  final bool modifying;
  final Function onSave;
  Indicator(
      {Key key,
      this.textOfIndicator,
      this.modifying,
      this.dataPercent,
      this.dataDistance,
      this.dataTime,
      this.id,
      this.onSave})
      : super(key: key);

  @override
  _IndicatorState createState() => _IndicatorState(
        textOfIndicator: textOfIndicator,
        modifying: modifying == null ? true : modifying,
        dataDistance: dataDistance,
        dataPercent: dataPercent,
        dataTime: dataTime,
        id: id,
      );
}

class _IndicatorState extends State<Indicator> {
  final String textOfIndicator;

  final dataTime;
  final dataDistance;
  final double dataPercent;
  final int id;
  bool modifying;
  bool change;

  _IndicatorState({
    this.textOfIndicator,
    this.modifying,
    this.dataTime,
    this.dataDistance,
    this.dataPercent,
    this.id,
  });

  List logic(double percent, double width) {
    Color color;
    double widthOfIndicator;

    if (percent < 0.5) {
      color = Color.fromRGBO(165, 235, 120, 1);
    } else if (percent >= 0.5 && percent < 0.8) {
      color = Color.fromRGBO(255, 204, 51, 1);
    } else if (percent >= 0.8) {
      setState(() {
        change = true;
      });
      color = Color.fromRGBO(223, 88, 103, 1);
    }

    widthOfIndicator = width * percent + width * 0.02;
    if (widthOfInidcator != null && widthOfInidcator > width) {
      widthOfInidcator = width;
    }
    return [color, widthOfIndicator];
  }

  void deleteObject(UserProvider provider) {
    setState(() {
      this.delete = true;
      if (this.dataPercent >= 0.8)
        provider.setChangeDetails(
            provider.changeDetail == 0 ? 0 : provider.changeDetail - 1);
      Future.delayed(Duration(milliseconds: 300)).then((value) {provider.deletedIndicators.add(id);});
      SingletonUserInformation().cards.card.removeWhere((element) => element.id==id);
    });
   final result =  http.delete('${SingletonConnection.URL}/cards/$id/?id_cards=${SingletonUserInformation().cards.id}');
   result.then((value) => print(value.body));
  }

  Color color;
  double width;
  double widthOfInidcator;
  bool delete = false;
  var colorAndWidth;

  void setInitialVartiables(double width) {
    setState(() {
      colorAndWidth = logic(dataPercent, width);
      color = colorAndWidth[0];
      widthOfInidcator = colorAndWidth[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    setInitialVartiables(width);
    final provider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () async{

        if (modifying == true) {
          SingletonUserInformation().setNewCard(id);
          final result = Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ModifyCards(
                appBarName: textOfIndicator,
                child: ChangeNotifierProvider.value(
                  value: provider,
                  child: Indicator(
                    textOfIndicator: textOfIndicator,
                    dataPercent: dataPercent,
                    dataTime: dataTime,
                    dataDistance: dataDistance,
                    id: id,
                    modifying: false,
                  ),
                ),
              ),
            ),
          );
          result.then((value) {
            print("RETURN VALUE $value");
            provider.setClean();
            if (value == null) {
              SingletonUserInformation().newCardClean();
            } else {
              provider.setLoading(true);
              SingletonConnection().modifyCard();
              int expenses = SingletonUserInformation().expenses.all_time;
              int month = SingletonUserInformation().expenses.in_this_month;
              provider.setExpenseAll(expenses);
              provider.setExpenseMonth(month);
              SingletonConnection().updateExpenses();
              provider.setRun(SingletonUserInformation().run);
              SingletonUserInformation().averageRun();
              provider.setAverageRun(SingletonUserInformation().average);
              SingletonUserInformation()
                  .newCard
                  .attach
                  .uploadedImage
                  .forEach((element) {
                SingletonUserInformation().newCard.attach.image.add(element);
              });
              SingletonUserInformation().newCard.attach.clean();
              int index;
              SingletonUserInformation().newCard.change.setInitialRun(SingletonUserInformation().run);
              SingletonUserInformation().cards.card.where((element) => element.id==SingletonUserInformation().newCard.id).forEach((element) {
                index = SingletonUserInformation().cards.card.indexOf(element);
              });
              SingletonUserInformation().cards.card.removeAt(index);
              if(value){
                SingletonUserInformation().cards.card.insert(index, SingletonUserInformation().newCard);
              }else{
                this.deleteObject(provider);
              }
              provider.setIndicators(SingletonUserInformation().indicators());
              provider.setChanged(true);
              provider.setLoading(false);
              SingletonUserInformation().newCardClean();
            }
          });
        }
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: delete ? 0 : width * 0.3,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                width * 0.02, width * 0.02, width * 0.02, width * 0.02),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Expanded(
                //   flex: 2,
                //   child: Visibility(
                //     visible: modifying,
                //     child: Align(
                //       alignment: Alignment.topRight,
                //       child: GestureDetector(
                //         onTap: () => deleteObject(provider),
                //         child: SvgPicture.asset(
                //           "assets/cross.svg",
                //           height: width * 0.1,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: delete ? 0 : width * 0.01,
                // ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "на  ${dataDistance is double ?dataDistance.toInt():dataDistance} ${SingletonUnits().distance}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: HexColor("42424A"),
                          fontFamily: 'Roboto',
                          fontSize: width * 0.03),
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                        dataTime is int || dataTime is double? "через ${dataTime.toInt()} ${SingletonUnits().convertDaysToString(dataTime.toInt())}":dataTime,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: HexColor("42424A"),
                          fontFamily: 'Roboto',
                          fontSize: width * 0.03),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      textOfIndicator,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: delete ? 0 : width * 0.01,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        height: width * 0.05,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(201, 202, 206, 1),
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: width * 0.05,
                        width: widthOfInidcator,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: delete ? 0 : width * 0.05,
          )
        ],
      ),
    );
  }
}
