//shared preferences
import 'package:shared_preferences/shared_preferences.dart';

setPreference(String key, String value) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  } catch (e) {
    print(e);
  }
}

storeBool(String key, bool value) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  } catch (e) {
    print(e);
  }
}

//Get bool
Future<bool?> getBool(String key) async {
  bool? response;
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    response = pref.getBool(key);
  } catch (e) {
    print(e);
  }
  return response;
}

//shared preferences
Future<String?> getPreference(String key) async {
  String? response;
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    response = pref.getString(key);
  } catch (e) {
    print(e);
  }
  return response;
}

Future<bool> removePreference(String key) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool done = await pref.remove(key);
    return done;
  } catch (e) {
    print(e);
  }
  return false;
}
