import 'dart:io';

import 'dart:typed_data';

import 'SingletonUnits.dart';


class SingletonRecomendation {
  int _id;
  String _textAbove;
  String _imageName;
  List<Recomendations> _recomendations = [];
  Recomendations _choosenRecommendation;
  File _image;
  Uint8List _imageUnit;

  int get id => _id;
  Recomendations get choosenRecommendation => _choosenRecommendation;
  String get textAbove => _textAbove;

  File get image => _image;

  String get imageName => _imageName;

  Uint8List get imageUnit => _imageUnit;

 int checkRecomm(String input){
   return chosenRecommend(input) != null?1:0;
 }
  void setImage(File image) {
    _image = image;
  }
  void clean(){
    _recomendations = [];
  }
  void setImageUnit(Uint8List imageUnit) {
    _imageUnit = imageUnit;
  }

  static final SingletonRecomendation _instance =
      SingletonRecomendation._internal();

  factory SingletonRecomendation() {
    return _instance;
  }

  Recomendations chosenRecommend(String inputData){
    if (inputData == null || inputData.isEmpty) {
      return null;
    }
    _choosenRecommendation = _recomendations.firstWhere((element) => element._mainName == inputData, orElse: ()=> null);
    return _choosenRecommendation;
  }

  double recommendationProbeg(String inputData) {
    Recomendations input = chosenRecommend(inputData);
    double  run;
    if (input != null)
    run = SingletonUnits().convertDistanceForUser(input._recomendedProbeg);
    return run;

  }

  void fromJson(Map<String, dynamic> json) {
    _id = json['id_model'];
    _textAbove = json['text_above'];
    _imageName = json['image_name'];
    json['recomendations']
        .forEach((e) => _recomendations.add(new Recomendations(e)));
  }

  List choicesCreateCard() {
    List choices = [];
    _recomendations.forEach((element) => choices.add(element._mainName));
    return choices;
  }

  List recommendationAll() {
    List choices = [];
    _recomendations.forEach(
        (element) => choices.add([element._mainName, element._description]));
    return choices;
  }

  SingletonRecomendation._internal();
}

class Recomendations {
  int _id;
  String _mainName;
  String _description;
  double _recomendedProbeg;

  String get mainName => _mainName;
  String get description => _description;

  Recomendations(Map<String, dynamic> json) {
    _id = json['id'];
    _mainName = json['main_name'];
    _description = json['description'];
    _recomendedProbeg = json['recomended_probeg'];
  }
}
