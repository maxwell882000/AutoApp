import 'dart:convert';

import 'SingletonStoreToTheDiskAndLoad.dart';
import 'SingletonStoreUnits.dart';
import 'package:get/get.dart';


class SingletonUnits {
  String _speed;
  String _distance;
  String _fuelConsumption;
  String _currency;
  String _time;
  String _speedDistance;
  static final SingletonUnits _instance = SingletonUnits._internal();

  factory SingletonUnits() {
    return _instance;
  }

  String get speed => _speed;

  String get distance => _distance;

  String get fuelConsumption => _fuelConsumption;

  String get currency => _currency;
  String get time => _time;
  String get speedDistance => _speedDistance;
  void setSpeed(String speed) {
    this._speed = speed;
  }

  void setDistance(String distance) {
    this._distance = distance;
  }

  void setFuelConsumption(String fuelConsumption) {
    this._fuelConsumption = fuelConsumption;
  }

  void setCurrency(String currency) {
    this._currency = currency;
  }

  Map<String, dynamic> toJson() => {
        'speedUnit': _speed,
        'distanseUnit': _distance,
        'fuelConsumption': _fuelConsumption,
        'volume': _currency,
      };

  void fromJson(Map<String, dynamic> json) {
    _speed = json['speedUnit'];
    _distance = json['distanseUnit'];
    _fuelConsumption = json['fuelConsumption'];
    _currency = json['volume'];
  }

  double convertDistanceForDB(double run) {
    if (distance == SingletonStoreUnits().distance.MM) {
      return run / (1000 * 1000);
    } else if (distance == SingletonStoreUnits().distance.CM) {
      return run / (1000 * 100);
    } else if (distance == SingletonStoreUnits().distance.M) {
      return run / 1000;
    } else if (distance == SingletonStoreUnits().distance.KM) {
      return run;
    }
  }

  double convertDistanceForUser(double run) {
    return translateDistance(distance, run);
  }
  double translateDistance(String distance,double run) {
  if (distance == SingletonStoreUnits().distance.MM) {
  return run * 1000 * 1000;
  } else if (distance == SingletonStoreUnits().distance.CM) {
  return run * 1000 * 100;
  } else if (distance == SingletonStoreUnits().distance.M) {
  return run * 1000;
  } else if (distance == SingletonStoreUnits().distance.KM) {
  return run;
  }
}
 int translateTimeFromDays(String time, int days){
    print("time $time and other type ${SingletonStoreUnits().time.S} ");
    print("compareTo ${time.compareTo(SingletonStoreUnits().time.S)}");
    print("check ${time ==SingletonStoreUnits().time.S}");
   if (time == SingletonStoreUnits().time.S) {
     _time = SingletonStoreUnits().time.S;
     return days* 86400;
   } else if (time == SingletonStoreUnits().time.H) {
     _time =SingletonStoreUnits().time.H;
     return days*24;
   } else if (time == SingletonStoreUnits().time.D) {
     _time = SingletonStoreUnits().time.D;
     return days;
   } else if (time == SingletonStoreUnits().time.Y) {
     _time = SingletonStoreUnits().time.Y;
     return days~/365;
   }
 }
  int translateTimeToDays(String time, int period){
    if (time == SingletonStoreUnits().time.S) {
      _time = SingletonStoreUnits().time.S;
      return period~/24~/60~/60;
    } else if (time == SingletonStoreUnits().time.H) {
      _time =SingletonStoreUnits().time.H;
      return period~/24;
    } else if (time == SingletonStoreUnits().time.D) {
      _time = SingletonStoreUnits().time.D;
      return period;
    } else if (time == SingletonStoreUnits().time.Y) {
      _time = SingletonStoreUnits().time.Y;
      return period*365;
    }
  }
  double convertSpeedForUser(double run,int days) {
    print("SPEED $speed amd ${SingletonStoreUnits().speed.KM_C} and ${speed == SingletonStoreUnits().speed.KM_C} and "
        "${SingletonStoreUnits().speed.M_D.compareTo(speed)}");
    RegExp regExp = new RegExp(SingletonStoreUnits().speed.KM_C.toLowerCase().trim());
    String sp = speed.split("/").first;
    String dd = speed.split("/").last;
    _speedDistance = sp;
    print(sp);
    print(dd);
    print(translateDistance(sp, 1));
    print("KM EQUAL OR NOT ");
    return _averageFind(run, sp, days, dd);
    // print(regExp.stringMatch(speed.toLowerCase().trim()));
    // if (speed == SingletonStoreUnits().speed.M_D) {
    //   _speedDistance = SingletonStoreUnits().distance.M;
    //   return _averageFind(run, SingletonStoreUnits().distance.M, days, SingletonStoreUnits().time.D);
    // } else if (speed == SingletonStoreUnits().speed.M_Y) {
    //   _speedDistance = SingletonStoreUnits().distance.M;
    //   return _averageFind(run, SingletonStoreUnits().distance.M, days, SingletonStoreUnits().time.Y);
    // } else if (speed == SingletonStoreUnits().speed.M_H) {
    //   _speedDistance = SingletonStoreUnits().distance.M;
    //   return _averageFind(run, SingletonStoreUnits().distance.M, days, SingletonStoreUnits().time.H);
    // } else if (speed == SingletonStoreUnits().speed.M_C) {
    //   _speedDistance = SingletonStoreUnits().distance.M;
    //   return _averageFind(run, SingletonStoreUnits().distance.M, days, SingletonStoreUnits().time.S);
    // } else if (speed == SingletonStoreUnits().speed.KM_D) {
    //   _speedDistance = SingletonStoreUnits().distance.KM;
    //   return _averageFind(run, SingletonStoreUnits().distance.KM, days, SingletonStoreUnits().time.D);
    // } else if (speed == SingletonStoreUnits().speed.KM_Y) {
    //   _speedDistance = SingletonStoreUnits().distance.KM;
    //   return _averageFind(run, SingletonStoreUnits().distance.KM, days, SingletonStoreUnits().time.Y);
    // } else if (speed == SingletonStoreUnits().speed.KM_H) {
    //   _speedDistance = SingletonStoreUnits().distance.KM;
    //   return _averageFind(run, SingletonStoreUnits().distance.KM, days, SingletonStoreUnits().time.H);
    // } else if (speed == SingletonStoreUnits().speed.KM_C) {
    //   _speedDistance = SingletonStoreUnits().distance.KM;
    //   print("SPEED"+_speedDistance +"RUN " + run.toString() + "DAYS " + days.toString());
    //   return _averageFind(run, SingletonStoreUnits().distance.KM, days, SingletonStoreUnits().time.S);
    // }
  }
  double _averageFind(double run, String translateRun, int days, String time){
    print("TIME $time");
    print("DAYS $days");
        double translatedRun = translateDistance(translateRun, run);
        print("TIME $time");
        print("DAYS $days");
        int translatedTime = translateTimeFromDays(time,days);
        print("FIRST $translatedTime");
        print("FIRST $translatedRun");
        return translatedRun/translatedTime;
  }
  void setToTheDisk() {
    SingletonStoreToTheDiskAndLoad().setToDisk('unit', json.encode(toJson()));
  }
  String convertDaysToString(int days){
    int d = days%10;
    if (d == 1){
      return "день".tr;
    }
   else if (d >=2 && d <=4){
      return "дня".tr;
    }
   else {
     return "дней".tr;
    }
  }
  @override
  String toString() {
    return toJson().toString();
  }

  void getFromTheDisk() async {
    String result = await SingletonStoreToTheDiskAndLoad().getFromDisk('unit');
    fromJson(json.decode(result));
  }

  SingletonUnits._internal();
}
