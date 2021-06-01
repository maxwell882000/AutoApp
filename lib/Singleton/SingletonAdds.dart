import 'dart:typed_data';

class SingletonAdds {

  String  _links;
  Uint8List _image;

  static final SingletonAdds _instance = SingletonAdds._internal();
  factory SingletonAdds() {
    return _instance;
  }
  String get links => _links;
  Uint8List get image => _image;

  void setImages(Uint8List image){
    _image =image;
  }
  void setLinks(String links){
    _links = links;
  }

  SingletonAdds._internal();
}