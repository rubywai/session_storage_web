import 'package:shared_preferences/shared_preferences.dart';

class MyPreferenceStorage {
  static SharedPreferences? _sharedPreferences;
  static Future<void> initStorage() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences getPreference() {
    return _sharedPreferences!;
  }
}
