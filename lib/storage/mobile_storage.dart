import 'package:shared_preferences/shared_preferences.dart';
import '../const/storage_key.dart';
import 'my_preference_storage.dart';

SharedPreferences sharedPreferences = MyPreferenceStorage.getPreference();
void saveLoginInfo({
  required bool isDarkTheme,
  required String email,
  required String password,
  required bool isRemember,
  required String userType,
}) {
  sharedPreferences.setBool(themeKey, isDarkTheme);
  sharedPreferences.setString(emailKey, email);
  sharedPreferences.setString(passwordKey, password);
  sharedPreferences.setBool(rememberKey, isRemember);
  sharedPreferences.setString(userTypeKey, userType);
}

bool? getTheme() => sharedPreferences.getBool(themeKey);
bool? getRemember() => sharedPreferences.getBool(rememberKey);
String? getEmail() => sharedPreferences.getString(emailKey);
String? getPassword() => sharedPreferences.getString(passwordKey);
String? getUserType() => sharedPreferences.getString(userTypeKey);
