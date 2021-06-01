
import 'package:flutter/cupertino.dart';

class FeeProvider with ChangeNotifier {
  int _id;
  String _name;
  String _sum;
  String _amount;
  bool _delete;
  bool _finish;
  bool _error;
  FeeProvider.downloaded(int id, String name, String sum, String amount){
    _id = id;
    _name = name;
    _sum = sum;
    _amount = amount;
    _finish = false;
    _delete =false;
    _error = false;
  }
  FeeProvider() {
      _name = "";
      _sum = "";
      _amount = "1";
      _finish = false;
      _delete =false;
      _error = false;
  }
  int get id => _id;
  bool get error => _error;
  bool get finish => _finish;
  String get name => _name;
  String get sum => _sum;
  String get amount => _amount;
  bool get delete =>_delete;
  void setError(bool error){
    _error =error;
    notifyListeners();
  }
  void setFinish(bool finish){
    _finish = finish;
    notifyListeners();
  }
  void setId(int id){
    _id = id;
    notifyListeners();
  }
  void setDelete(bool delete){
    _delete = delete;
    notifyListeners();
  }
  void setName(String name){
    _name = name;
    notifyListeners();
  }
  void setSum(String sum){
    _sum = sum;
    notifyListeners();
  }
  void setAmount(String amount){
    _amount = amount;
    notifyListeners();
  }

}
