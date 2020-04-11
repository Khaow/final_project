import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class abc extends StatefulWidget {
  final DocumentSnapshot ds;

  abc({this.ds});

  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<abc> {
  TextEditingController _commentsController1 = new TextEditingController();
  String _comments = 'เพิ่มความคิดเห็น...';
  String productImage;
  String id;
  String name;
  String address;
  String call;
  String price;
  String facility;
  List comments = [];

  TextEditingController nameInputController;

  Future getPost() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
        await firestore.collection("ProjectDindaeng").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    productImage = widget.ds.data["image"];
    print(productImage);
    comments = widget.ds.data["comments"];
  }

  @override
  Widget build(BuildContext context) {
    getPost();
    return Scaffold(
      appBar: AppBar(
        title: Text('Information Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(5.0),
                      child: productImage == ''
                          ? Text('Edit')
                          : Image.network(productImage + '?alt=media'),
                    ),
                  ],
                ),
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: nameInputController,
                    validator: (value) {
                      if (value.isEmpty) return "Ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: "Name", labelText: "Name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Text('Hey'),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: this.comments.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(right: 10.0)),
                              Text(
                                this.comments[index],
                                style: TextStyle(fontSize: 20.0),
                              )
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IniciarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new IconoMenu(
            icon: Icons.call,
            label: "Call",
          ),
          new IconoMenu(
            icon: Icons.message,
            label: "Message",
          ),
          new IconoMenu(
            icon: Icons.place,
            label: "Place",
          ),
        ],
      ),
    );
  }
}

class IconoMenu extends StatelessWidget {
  IconoMenu({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          new Text(
            label,
            style: new TextStyle(fontSize: 12.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
