import 'package:flutter/cupertino.dart';

class SelectOptionsErrorProvider with ChangeNotifier {
  List _errorsMessageWithText;
  SelectOptionsErrorProvider() {
    this._errorsMessageWithText = [];
  }
  List get errorsMessageWithText => _errorsMessageWithText;

  void setErrorsMessageWithText(List errorsMessageWithText) {
    this._errorsMessageWithText.add(errorsMessageWithText);
    notifyListeners();
  }
}
