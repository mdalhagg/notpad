import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class SettingsService {
  var settingsBox = Hive.box('settings');
  var userBox = Hive.box('user');

  Future<void> printAll() async {
    // log("settings: ${settingsBox.toMap().toString()}", name: "SettingsService");
    // log("cart: ${cartBox.toMap().toString()}", name: "SettingsService");
    // log("user: ${userBox.toMap().toString()}", name: "SettingsService");
  }

  Future<ThemeMode> thememode() async {
    String? theme = await settingsBox.get('theme');
    if (theme == 'system') {
      return ThemeMode.system;
    } else if (theme == 'light') {
      return ThemeMode.light;
    } else if (theme == 'dark') {
      return ThemeMode.dark;
    } else {
      // return Thememode.system;
      return ThemeMode.light;
    }
  }

  Future<Locale> locale() async {
    String? data = await settingsBox.get('locale');

    return data != null ? Locale(data, '') : const Locale('ar', '');
  }

  Future<bool> intro() async {
    var data = await settingsBox.get('intro');

    return data != null ? data == 'true' : false;
  }

  Future<User?> user() async {
    var data = await userBox.get('user');
    if (data != null) {
      data = data?.replaceAll("\\", "");
      data = data.substring(1, data.length - 1);
      // log(data.toString());
      User? userData;
      try {
        userData = User.fromJson(
          jsonDecode(data),
        );
      } catch (e) {
        await userBox.delete('user');
        return null;
      }

      return userData;
    } else {
      return null;
    }
  }

  // Future http(url) async {
  //   var httpBox = Hive.box(url);
  //   var data = await httpBox.get(url);
  //   if (data != null) {
  //     data = data?.replaceAll("\\", "");
  //     data = data.substring(1, data.length - 1);
  //     // log(data.toString());
  //     // ignore: prefer_typing_uninitialized_variables
  //     var http;
  //     try {
  //       http = jsonDecode(data);
  //     } catch (e) {
  //       await httpBox.delete(url);
  //       return null;
  //     }

  //     return http;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<void> updateHttp(url, data) async {
  //   var httpBox = Hive.box(url);
  //   await httpBox.put(
  //     url,
  //     jsonEncode(data),
  //   );
  // }
  // // getHttp(url)

  Future<void> updateThemeMode(ThemeMode theme) async =>
      await settingsBox.put(
        "theme",
        theme.name,
      );

  Future<void> updateLocale(Locale locale) async => await settingsBox.put(
        "locale",
        locale.languageCode,
      );

  Future<void> updateUser(String data) async => await userBox.put(
        'user',
        jsonEncode(data),
      );

  Future<void> updateIntro(bool status) async => await settingsBox.put(
        'intro',
        status.toString(),
      );

  Future<void> removeUser() async => await userBox.clear();

  Future<String?> referralCode() async => await settingsBox.get(
        'referralCode',
        defaultValue: null,
      );

  Future<void> setReferralCode(String id) async =>
      await settingsBox.put('referralCode', id);

  Future<void> removeReferralCode() async =>
      await settingsBox.delete('referralCode');
}
