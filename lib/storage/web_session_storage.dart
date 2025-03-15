import 'package:web/web.dart';
import '../const/storage_key.dart';

Storage sessionStorage = window.sessionStorage;
Storage localStorage = window.localStorage;
void saveLoginInfo({
  required bool isDarkTheme,
  required String email,
  required String password,
  required bool isRemember,
  required String userType,
}) {
  Storage sessionStorage = window.sessionStorage;
  if (userType == 'user') {
    sessionStorage = localStorage;
  }
  sessionStorage.setItem(themeKey, isDarkTheme.toString());
  sessionStorage.setItem(emailKey, email);
  sessionStorage.setItem(passwordKey, password);
  sessionStorage.setItem(rememberKey, isRemember.toString());
  sessionStorage.setItem(userTypeKey, userType);
}

bool? getTheme() => sessionStorage.getItem(themeKey) == "true";
bool? getRemember() => sessionStorage.getItem(rememberKey) == "true";
String? getEmail() => sessionStorage.getItem(emailKey);
String? getPassword() => sessionStorage.getItem(passwordKey);
String? getUserType() => sessionStorage.getItem(userTypeKey);
