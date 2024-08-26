// ignore: unused_import
import 'package:flutter/foundation.dart';

class API {
  static String baseUrl = "http://172.16.60.124:8000/api/";
  static String imageBaseUrl = "http://172.16.60.124:8000/upload/memes/";

  // static String baseUrl = "http://172.16.60.114/delivery_application/api/";
  // static String imageBaseUrl =
  //     "http://172.16.60.114/delivery_application/public/images/";

  // home
  static String memo = "memos";
  static String categories = "categories";

  // user
  static String info = "user/get";
  static String auth = "user/login";
  static String updateProfile = "user/update";
  static String profileDelete = "user/delete";
}
