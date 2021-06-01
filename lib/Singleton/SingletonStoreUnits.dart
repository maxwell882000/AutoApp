import 'package:get/get.dart';
class SingletonStoreUnits {
  final Distance _distance = new Distance();
  final Speed _speed = new Speed();
  final FuelConsumption _fuelConsumption = new FuelConsumption();
  final Time _time = new Time();
  final Currency _currency = new Currency();
  static final SingletonStoreUnits _instance = SingletonStoreUnits._internal();
  Distance get distance => _distance;
  Speed get speed => _speed;
  FuelConsumption get fuelConsumption => _fuelConsumption;
  Currency get currency => _currency;
  Time get time => _time;
  factory SingletonStoreUnits() {
    return _instance;
  }
  SingletonStoreUnits._internal();
}


class Distance {
  final String M ='м';
  final String KM = 'км';
  final String MM ='мм';
  final String CM = 'см';
}
class Time{
  final String S = "с";
  final String H = "ч";
  final String D = "д";
  final String Y = "г";
}
class Speed {
  final String KM_C = "км/с";
  final String M_C = "м/с";
  final String KM_H = "км/ч";
  final String M_H = "м/ч";
  final String M_D = "м/д";
  final String KM_D = "км/д";
  final String M_Y= "м/г";
  final String KM_Y = "км/г";
}

class FuelConsumption {
  final String KM_L = "км/л";
  final String L_KM = "л/км";
  final String L_100KM = "л/100км";
}
class Currency {
  final String USD = "USD";
  final String EUR = "EUR";
  final String UZS = "UZS";
  final String RUB = "RUB";
}