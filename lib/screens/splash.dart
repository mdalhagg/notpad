import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_pad/models/user.dart';
import '../router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    settingsController.addListener(() {
      if (mounted) {
        settingsController.loadSettings();
        setState(() {});
      }
    });
    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () async {
        print('hi');
        context.pushReplacement('/home');
        // if (settingsController.user != null) {
        //   print('hi');
        //   context.push('/home');
        // } else {
        //   if (settingsController.user?.username == "") {
        //     context.push('/register');
        //   } else {
        //     if (settingsController.user?.isLogin == false) {
        //       context.push('/login');
        //     }
        //   }
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'Splash Screen',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      )),
    );
  }
}
