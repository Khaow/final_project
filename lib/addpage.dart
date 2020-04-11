import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

File image;
String filename;

class CommonThings {
  static Size size;
}

class MyAddPage extends StatefulWidget {
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  TextEditingController _latitudeController1 = new TextEditingController();
  TextEditingController _longitudeController1 = new TextEditingController();
  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String price;
  String address;
  String call;
  String facility;
  String line;
  double _latitude;
  double _longitude;

  _buildfirstnameField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'ชื่อ',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'โปรดใส่ชื่อห้องพัก';
          }
        },
        onSaved: (value) => name = value,
      ),
    );
  }

  _buildLineField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'LINE ID',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'โปรดใส่ชื่อห้องพัก';
          }
        },
        onSaved: (value) => line = value,
      ),
    );
  }

  _buildlatitudeField() {
    return SizedBox(
      width: 110,
      child: TextFormField(
        controller: _latitudeController1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'latitude',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  _buildlongitudeField() {
    return SizedBox(
      width: 110,
      child: TextFormField(
        controller: _longitudeController1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'longitude',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  void createData() async {
    setState(() {
      _latitude = double.parse(_latitudeController1.text);
      _longitude = double.parse(_longitudeController1.text);
    });
    DateTime now = DateTime.now();
    String dindaengphoto = DateFormat('kk:mm:ss:MMMMd').format(now);
    var fullImageName = 'ProjectDindaeng-$dindaengphoto' + '.jpg';

    final StorageReference ref =
        FirebaseStorage.instance.ref().child(fullImageName);
    final StorageUploadTask task = ref.putFile(image);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    var fullPathImage = url;
    print(url);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      DocumentReference ref = await db.collection('ProjectDindaeng').add({
        'name': '$name',
        'price': '$price',
        'call': '$call',
        'facility': '$facility',
        'address': '$address',
        'line': '$line',
        'image': '$fullPathImage',
        'comments': FieldValue.arrayUnion([]),
        'latitude': FieldValue.increment(_latitude),
        'longitude': FieldValue.increment(_longitude),
        'location': GeoPoint(_latitude, _longitude),
      });
      setState(() => id = ref.documentID);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มห้องพัก',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null
                          ? Text(
                              'เพิ่มรูปภาพห้องพัก',
                              style: TextStyle(fontSize: 20),
                            )
                          : Image.file(image),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    'รายละเอียดห้องพัก',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ชื่อห้องพัก',
                      style: TextStyle(fontSize: 20),
                    ),
                    _buildfirstnameField(),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/1586517537871.jpg'),
                      height: 40,
                    ),
                    _buildLineField(),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ราคาเดือนละ ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'ราคาเดือนละ',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'โปรดใส่ชื่อห้องพัก';
                          }
                        },
                        onSaved: (value) => price = value,
                      ),
                    ),
                    Text('บาท/เดือน'),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'สิ่งอำนวยความสะดวก ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        maxLines: 5,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'มีอะไรบ้าง',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'โปรดใส่ชื่อห้องพัก';
                          }
                        },
                        onSaved: (value) => facility = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'เบอร์โทรศัพท์ ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'เบอร์โทรศัพท์',
                          hintStyle: TextStyle(fontSize: 15),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'โปรดใส่ชื่อห้องพัก';
                          }
                        },
                        onSaved: (value) => call = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'พิกัดบนแผนที่       ',
                      style: TextStyle(fontSize: 20),
                    ),
                    _buildlatitudeField(),
                    _buildlongitudeField(),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ที่อยู่ห้องพัก ',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        maxLines: 4,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'โปรดใส่ที่อยู่',
                          hintStyle: TextStyle(fontSize: 15),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'โปรดใส่ชื่อห้องพัก';
                          }
                        },
                        onSaved: (value) => address = value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('ยืนยันข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }
}
