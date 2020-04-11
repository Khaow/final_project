import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';

class map extends StatefulWidget {
  const map({@required this.title});

  final String title;

  @override
  _map createState() => _map();
}

class _map extends State<map> {
  Stream<QuerySnapshot> _iceCreamStore;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _iceCreamStore = Firestore.instance
        .collection('ProjectDindaeng')
        .orderBy('name')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: Text(''),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _iceCreamStore,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: const Text('Loading...'),
            );
          }
          return Stack(
            children: [
              StoreMap(
                documents: snapshot.data.documents,
                initialPosition: const LatLng(13.7797768, 100.5577699),
                mapController: _mapController,
              ),
              StoreCarousel(
                documents: snapshot.data.documents,
                mapController: _mapController,
              ),
            ],
          );
        },
      ),
    );
  }
}

class StoreCarousel extends StatelessWidget {
  const StoreCarousel({
    Key key,
    @required this.documents,
    @required this.mapController,
  }) : super(key: key);
  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 90,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 340,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Card(
                      child: Center(
                        child: StoreListTile(
                            document: documents[index],
                            mapController: mapController),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key key,
    @required this.document,
    @required this.mapController,
  }) : super(key: key);
  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

//final _placesApiClient = GoogleMapsPlaces(apiKey: googleMapsApiKey);

class _StoreListTileState extends State<StoreListTile> {
//  String _placePhotoUrl = '';
//  bool _disposed = false;
//
//  @override
//  void initState() {
//    super.initState();
//    _retrievePlacesDetails();
//  }
//
//  @override
//  void dispose() {
//    _disposed = true;
//    super.dispose();
//  }

//  Future<void> _retrievePlacesDetails() async {
//    final details =
//        await _placesApiClient.getDetailsByPlaceId(widget.document['image']);
//    if(!_disposed){
//      setState(() {
//        _placePhotoUrl = _placesApiClient.buildPhotoUrl(photoReference: details.result.photos[0].photoReference,
//        maxHeight: 300,
//        );
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['name']),
      subtitle: Text(
        widget.document['price'].toString() + '  บาท/เดือน',
        style: TextStyle(fontSize: 17),
      ),
      leading: Container(
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(24.0),
          child: Image(
            fit: BoxFit.fill,
            image: NetworkImage(widget.document['image']),
          ),
        ),
        width: 100,
        height: 60,
      ),
      onTap: () async {
        final controller = await widget.mapController.future;
        await controller
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            widget.document['location'].latitude,
            widget.document['location'].longitude,
          ),
          zoom: 16,
        )));
      },
    );
  }
}

const _pinkHue = 350.0;

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
    @required this.mapController,
  }) : super(key: key);
  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12,
      ),
      markers: documents
          .map((document) => Marker(
              markerId: MarkerId(document['image']),
              icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
              position: LatLng(
                document['location'].latitude,
                document['location'].longitude,
              ),
              infoWindow: InfoWindow(
                title: document['name'],
                snippet: document['address'],
              )))
          .toSet(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }
}
