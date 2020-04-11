import 'package:flutter/material.dart';
import 'state_widget.dart';
import 'theme.dart';
import 'home.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'forgot_password.dart';

class MyApp5 extends StatelessWidget {
  MyApp5() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}
