import 'package:note_pad/screens/notes/category_form.dart';
import 'package:note_pad/screens/home.dart';
import 'package:note_pad/screens/login.dart';
import 'package:note_pad/screens/notes/note_form.dart';
import 'package:note_pad/screens/notes/category.dart';

import '../screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/settings.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    Page().getPage('/', const Splash()),
    // auth
    Page().getPage('/login', const Login()),
    Page().getPage('/register', const Login()),
    // home
    Page().getPage('/home', const Home()),
    // note
    Page().getPage('/add', const NoteFormScreen()),
    Page().getPage('/add_category', const CategoryFormScreen()),
    Page().getPage('/notes', const ScreenManager()),
  ],
);

final SettingsController settingsController = SettingsController();

class Page {
  getPage(name, page) {
    return GoRoute(
      path: name,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(microseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 700),
          key: state.pageKey,
          child: page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    );
  }
}
