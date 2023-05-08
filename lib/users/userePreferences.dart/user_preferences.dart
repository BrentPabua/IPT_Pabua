import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/users/model/user.dart';

class RememberUserPrefs
{
  static Future<void> saveRememberUser(User userInfo) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

}