import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/statefull_wrapper.dart';
import 'package:flutter_projects/Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../LoadingScreen.dart';
import 'Indicator.dart';


class ListOfIndicator extends StatefulWidget {
  final Function onLoad;
  final double height;
  final Function getIndicators;
  ListOfIndicator({Key key, this.onLoad, this.height, this.getIndicators}) : super(key: key);

  @override
  _ListOfIndicatorState createState() => _ListOfIndicatorState();
}

class _ListOfIndicatorState extends State<ListOfIndicator> {
  List indicators;

  final allIndicators = <Widget>[].obs;

  @override
  void initState()  {
    super.initState();
    widget.onLoad().then((value) {
      setState(() {

        allIndicators.value = value;
      });
    });

  }

  // Widget getIndicators(List indicator) {
  //   return Indicator(
  //       key: UniqueKey(),
  //       textOfIndicator: indicator[0],
  //       dataPercent: indicator[1],
  //       dataTime: indicator[2],
  //       dataDistance: indicator[3],
  //       id: indicator[4]);
  // }

  void _delete(UserProvider provider) {
    if (provider.deletedIndicators.isNotEmpty) {
      List deleting = [];
      provider.deletedIndicators.forEach((el) {
        provider.indicators
            .where((element) => element[4] == el)
            .forEach((element) {
          deleting.add(element);
        });
      });

      deleting.forEach((element) {
        int index = provider.indicators.indexOf(element);
        allIndicators.removeAt(index);
        SingletonUserInformation()
            .cards
            .card
            .removeWhere((elem) => elem.id == element[4]);
        provider.indicators.remove(element);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.setClean();
        });
      });
    }
  }

  void sortChange(UserProvider provider) {
    allIndicators.clear();
    provider.indicators.sort((b, a) => a[1].compareTo(b[1]));
    allIndicators.value =
        provider.indicators.map((element) => widget.getIndicators(element)).toList();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => provider.setSortChange(false));
  }

  void sortRecent(UserProvider provider) {
    allIndicators.clear();

    int sMonth;
    int index;
    List zet = provider.indicators;
    for (int i = 0; i < zet.length; i++) {
      index = i;
      for (int k = i + 1; k < zet.length; k++) {
        int year = zet[index][5].year - zet[k][5].year;
        int month = zet[index][5].month - zet[k][5].month;
        int day = zet[index][5].day - zet[k][5].day;
        int hour = zet[index][5].hour - zet[k][5].hour;
        int minute = zet[index][5].minute - zet[k][5].minute;
        int sec = zet[index][5].second - zet[k][5].second;
        int ans = year != 0
            ? year
            : month != 0
                ? month
                : day != 0
                    ? day
                    : hour != 0
                        ? hour
                        : minute != 0
                            ? minute
                            : sec;
        if (ans < 0) {
          index = k;
        }
      }

      if (i != index) {
        List temp = zet[i];
        zet[i] = zet[index];
        zet[index] = temp;
      }
    }
    allIndicators.value = zet.map((element) => widget.getIndicators(element)).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setSortRecent(false);
    });
  }

  void sortUser(UserProvider provider) {
    List own = [];
    List def = [];
    provider.indicators.forEach((element) {
      if (SingletonRecomendation().checkRecomm(element[0]) == 1) {
        def.add(element);
      } else {
        own.add(element);
      }
    });
    own.addAll(def);

    allIndicators.value = own.map((element) => widget.getIndicators(element)).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setSortOfUser(false);
    });
  }

  void changed(UserProvider provider) {
    int count = 0;
    allIndicators.value = provider.indicators.map((indicator) {
      double handle = indicator[1];
      count = handle > 0.8 ? 1 + count : count;
      return widget.getIndicators(indicator);
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setChangeDetails(count);
      provider.setLoading(false);
      provider.setChanged(false);
    });
  }

  void _modified(UserProvider provider) {
    if (provider.indicators.isNotEmpty) {
      _delete(provider);
      if (provider.sortChange) {
        sortChange(provider);
      } else if (provider.sortRecent) {
        sortRecent(provider);
      } else if (provider.sortOfUser) {
        sortUser(provider);
      }
    }
    if (provider.changed) {
      changed(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<UserProvider>(context);
    if (provider != null) {
      _modified(provider);
    }

    return Stack(
      children: [
        Center(
          child: Align(
            alignment: Alignment.center,
            child: LoadingScreen(
              visible: provider.loading,
            ),
          ),
        ),
        Visibility(
          visible: !provider.loading,
          child: Container(
            width: double.infinity,
            height:widget.height ,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: allIndicators.toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
