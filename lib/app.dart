import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../router.dart';
import '../theme.dart';

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: LightTheme.main,
    ).harmonized();

    // log(lightColorScheme.toString());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    TextTheme textTheme = Theme.of(context).textTheme.apply(
          fontFamily: 'Tajawal-Regular',
        );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.dark, // Dark text for status bar
    ));

    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'NotPad',
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            textTheme: textTheme,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              // foregroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ).copyWith(
            textTheme: textTheme,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ).harmonized(),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              centerTitle: true,
              foregroundColor: DarkTheme.black,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
              ),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
                foregroundColor: DarkTheme.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: IconButton.styleFrom(
                foregroundColor: DarkTheme.white,
              ),
            ),
            iconTheme: IconThemeData(color: DarkTheme.main),
          ),
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
