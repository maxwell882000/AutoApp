import 'package:shared_preferences/shared_preferences.dart';

class SingletonStoreToTheDiskAndLoad {
  SharedPreferences _prefs;

  static final SingletonStoreToTheDiskAndLoad _instance = SingletonStoreToTheDiskAndLoad._internal();
  factory SingletonStoreToTheDiskAndLoad() {
    return _instance;
  }

  Future<void> setToDisk(String key, String data) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, data);

  }
  Future<String> getFromDisk(String key) async{
    _prefs = await SharedPreferences.getInstance();
   return _prefs.getString(key);
  }
  SingletonStoreToTheDiskAndLoad._internal();
}

