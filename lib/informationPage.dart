import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/for_test_only/test6.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'validator.dart';

class MyInfoPage extends StatefulWidget {
  final DocumentSnapshot ds;

  MyInfoPage({this.ds});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  TextEditingController _commentsController1 = new TextEditingController();
  String _comments;
  String productImage;
  String id;
  String name;
  String address;
  String call;
  String price;
  String facility;
  List comments = [];
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  double latitude;
  double longitude;
  String line;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("ProjectDindaeng").getDocuments();
    // print();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    productImage = widget.ds.data["image"];
    print(productImage);
    name = widget.ds.data["name"];
    address = widget.ds.data["address"];
    call = widget.ds.data["call"];
    line = widget.ds.data["line"];
    price = widget.ds.data["price"].toString();
    facility = widget.ds.data["facility"];
    comments = widget.ds.data["comments"];
    latitude = widget.ds.data["latitude"];
    longitude = widget.ds.data["longitude"];
  }

  _buildcommentsField() {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: _commentsController1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'เพิ่มความคิดเห็น...'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void alertcomment(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("ส่งความคิดเห็นเรียบร้อย"),
      content: Text("ขอบคุณครับ"),
      actions: <Widget>[
        FlatButton(
          child: Text('ตกลง'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียด',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 230.0,
                      width: 300.0,
                      child: productImage == ''
                          ? Text('Edit')
                          : Image.network(
                              productImage,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/images/image0.png'),
                        color: Colors.green,
                        size: 40,
                      ),
                      onPressed: () => Line(line),
                    ),
                    Text(
                      '$line',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.blue,
                      iconSize: 45,
                      onPressed: () => launch("tel://$call"),
                    ),
                    Text(
                      '$call',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.brown,
                      iconSize: 45,
                      onPressed: () => _openOnGoogleMapApp(latitude, longitude),
                    ),
                  ],
                ),
                new ListTile(
                  leading: Icon(Icons.home, color: Colors.purpleAccent),
                  title: new Text(
                    '$name',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.red),
                  title: new Text(
                    '$price' + ' บาท/เดือน',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: Icon(Icons.favorite, color: Colors.yellow),
                  title: new Text(
                    '$facility',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.brown,
                  ),
                  title: new Text(
                    '$address',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildcommentsField(),
                    ButtonTheme(
                      child: RaisedButton(
                          child: Text('ตกลง',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              _comments = _commentsController1.text;
                            });
                            Firestore.instance
                                .collection('ProjectDindaeng')
                                .document(widget.ds.documentID)
                                .updateData({
                              'comments': FieldValue.arrayUnion([_comments])
                            });
                            Navigator.of(context).deactivate();
                            alertcomment(context);
                          }),
                    ),
                  ],
                ),
                new ListTile(
                  leading: Icon(Icons.comment, color: Colors.lightBlueAccent),
                  title: new Text(
                    'ความคิดเห็นทั้งหมด',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this.comments.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(right: 10.0)),
                            Text(
                              this.comments[index],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_openOnGoogleMapApp(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    // Could not open the map.
  }
}

Line(String line) async {
  String googleUrl = 'https://line.me/R/ti/p/$line';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    // Could not open the map.
  }
}
