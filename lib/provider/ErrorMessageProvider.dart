
import 'package:flutter/material.dart';

class ErrorMessageProvider with ChangeNotifier {
  String _nameOfHelper;
  String _inputData;
  bool _error;
  bool _selected;
  bool _nextPage;
  bool _textField;
  List _errorsMessageWithText;
  List _items;
  bool _dispose = false;
  ErrorMessageProvider _errorMessageProvider;
  Widget _swapWidget;
  Widget _recommendations;

  ErrorMessageProvider.zero(){
    this._nextPage = false;
  }
  ErrorMessageProvider.cards({String nameOfHelper, String inputData}){
    this._nameOfHelper = nameOfHelper;
    this._inputData = inputData;
  }
  ErrorMessageProvider(String nameOfHelper) {
    this._nameOfHelper = nameOfHelper;
    this._error = false;
    this._selected = false;
    this._nextPage = false;
    this._textField = false;
    this._inputData = "";
    this._errorsMessageWithText = [];
    this._items = [];
  }
  List get errorsMessageWithText => _errorsMessageWithText;
  Widget get recommendations => _recommendations;
  bool get error => _error;
  String get nameOfHelper => _nameOfHelper;
  bool get selected => _selected;
  bool get nextPage => _nextPage;
  String get inputData => _inputData;
  bool get textField => _textField;
  List get items => _items;
  Widget get swapWidget => _swapWidget;
  void addItems(var items){
    _items.add(items);
    notifyListeners();
  }
  void setRecommendations(Widget recommendations){
    this._recommendations = recommendations;
    notifyListeners();
  }
  void setSwapWidget(Widget swapWidget){
    _swapWidget = swapWidget;
    notifyListeners();
  }
  void setItems(List items){
    this._items = items;
    notifyListeners();
  }

  void setInputData(String inputData) {
    this._inputData = inputData;
    notifyListeners();
  }

  void setErrorsMessageWithText(List errorsMessageWithText) {
    this._errorsMessageWithText.add(errorsMessageWithText);

  }
  ErrorMessageProvider newErrorMessageProvider(String nameOfHelper){
    this._errorMessageProvider = new ErrorMessageProvider(nameOfHelper);
    return _errorMessageProvider;
  }
  void setNextPage(bool nextPage) {
    this._nextPage = nextPage;
    notifyListeners();
  }
  void setTextField(bool textField) {
    this._textField = textField;
    notifyListeners();
  }

  void setError(bool error) {
    this._error = error;
    notifyListeners();
  }

  void setNameOfHelper(String nameOfHelper) {

    this._nameOfHelper = nameOfHelper;
    notifyListeners();
  }

  void setSelected(bool selected) {
    this._selected = selected;
    notifyListeners();
  }
  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }
  @override
  void notifyListeners() {
    if (!_dispose) {
      super.notifyListeners();
    }
  }
}
