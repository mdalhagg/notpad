
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../app.dart';

void main() async {
  await Hive.initFlutter().then((_) async {
    await Hive.openBox('settings');
    await Hive.openBox('user');
    await Hive.openBox('notes');
    await Hive.openBox('note_categories');

    // var a = Hive.box('http_cache').toMap();
    // log("$a", name: "main");
  });
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  const overlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(overlayStyle);

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
