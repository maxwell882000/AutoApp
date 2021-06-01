import 'package:flutter/cupertino.dart';

class CheckProvider with ChangeNotifier {
  bool _checked;
  List<CheckProvider> _items = [];
  CheckProvider() {
    _checked = false;
  }
  bool get checked => _checked;

  List<CheckProvider> get items =>_items;
  void clean(){
    _items = [];
  }
  void clicked(int id){
    items[id].setChecked(true);
    items.where((e) => items.indexOf(e)!= id).forEach((element) {element.setChecked(false);});
    notifyListeners();
  }

  void setChecked(bool checked) {
    this._checked = checked;
    notifyListeners();
  }

}
