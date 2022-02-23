import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:provider/provider.dart';

class AuctionMap extends StatefulWidget {
  @override
  _AuctionMapState createState() => _AuctionMapState();
}

class _AuctionMapState extends State<AuctionMap> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void initMarker({required dynamic specify, required String specifyId}) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Uint8List customMarker = await getBytesFromAsset(
        path: "assets/images/gavel_map_icon.png", //paste the custom image path
        width: 100 // size of custom image as marker
        );

    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(customMarker),
      position:
          LatLng(double.parse(specify['lat']), double.parse(specify['lng'])),
      infoWindow: InfoWindow(
        title: specify['title'],
        onTap: () {
          Provider.of<AuctionMapHelper>(context, listen: false)
              .showAuctionDetails(context: context, documentSnapshot: specify);
        },
        snippet: specify['description'],
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection("auctions").get().then((auctions) {
      for (int i = 0; i < auctions.docs.length; i++) {
        print(auctions.docs[i].data().toString());
        initMarker(specify: auctions.docs[i], specifyId: auctions.docs[i].id);
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(25.2048, 55.2708),
          zoom: 15,
        ),
        onMapCreated: (controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
