import 'package:flutter/material.dart';

main() => runApp(new MaterialApp(
      home: new AppHome(),
    ));

class AppHome extends StatefulWidget {
  @override
  State<AppHome> createState() {
    return new AppState();
  }
}

class AppState extends State<AppHome> {
  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("My List App"),
      ),
      body: new Container(
        child: new ListView.builder(
            reverse: false,
            itemCount: this.Names.length,
            itemBuilder: (_, int index) {
              return Card(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      Text(
                        this.Names[index],
                        style: TextStyle(fontSize: 20.0),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
//class EachList extends StatelessWidget{
//  final String name;
//  EachList(this.name);
//  @override
//  Widget build(BuildContext context) {
//    return new Card(
//      child: new Container(
//        padding: EdgeInsets.all(8.0),
//        child: new Row(
//          children: <Widget>[
//            new Padding(padding: EdgeInsets.only(right: 10.0)),
//            new Text(name,style: TextStyle(fontSize: 20.0),)
//          ],
//        ),
//      ),
//    );
//  }
//
//}
