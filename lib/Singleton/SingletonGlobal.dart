
import 'package:flutter/material.dart';
import 'package:flutter_projects/service/translation_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingletonGlobal {
  Languages _language;
  SharedPreferences _prefs;
  String _nameOfTheNextPage;
  List _images = [];
  List _expenses = [];
  static final SingletonGlobal _instance = SingletonGlobal._internal();
  factory SingletonGlobal() {
    return _instance;
  }

  SharedPreferences get prefs => _prefs;
  List get images => _images;
  List get expenses => _expenses;
  Languages get language => _language;
  Locale get locale {
    String _locale = _language != Languages.UZBEK? "ru" : "uz";
    return Get.find<TranslationService>().fromStringToLocale(_locale);
  }
  void saveLanguage(){
    prefs.setInt(
        'language', _language == Languages.UZBEK ? 1 : 0);
    Get.updateLocale(locale);
  }

  void getLocale(){
    int language = prefs.getInt('language') ?? -1;

    if (language == -1) {
      SingletonGlobal().setLanguageSecond(Languages.EMPTY);
    } else {
      SingletonGlobal().setLanguage(language);
    }

  }
  void setLanguageSecond(Languages languages) {
    this._language = languages;
  }
  void setLanguage(int language) {
    this._language =  language == 0 ? Languages.RUSSIAN : Languages.UZBEK;
  }
  void setImages(List images){
    _images =images;
  }
  void setExpenses(List expenses){
    _expenses = expenses;
  }

  void setPrefs(SharedPreferences prefs){
    _prefs = prefs;
    getLocale();
  }

  SingletonGlobal._internal();
}
enum MenuPOP{
  POP,
  NEW_TRANSPORT,
  CHANGE_TRANSPORT,
  NO_ACCOUNT,
}
enum Languages {
  EMPTY,
  UZBEK,
  RUSSIAN,
}

enum Requests{
  SUCCESSFULLY_CREATED,
  NOT_FOUND,
  BAD_REQUEST,
  NO_INTERNET
}