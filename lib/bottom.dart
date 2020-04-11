import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:path/path.dart';
import 'viewpage.dart';
import 'mapgoogle.dart';
import 'mainsignup.dart';
import 'state_widget.dart';
import 'informationPage.dart';
import 'sign_in.dart';

void main() {
  StateWidget stateWidget = StateWidget(
    child: MyApp3(),
  );
  runApp(stateWidget);
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    MyHomePage(),
    map(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(
            () {
              _selectedPage = index;
            },
          );
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('หน้าหลัก')),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('แผนที่')),
          //BottomNavigationBarItem(icon: Icon(Icons.done), backgroundColor: Colors.green, title: Text('Done'),),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('บัญชี')),
        ],
      ),
    );
  }
}
