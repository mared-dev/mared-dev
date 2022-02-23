import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/screens/mapscreen/mapscreenhelper.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker({required dynamic specify, required String specifyId}) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(double.parse(specify['lat']), double.parse(specify['lng'])),
      infoWindow: InfoWindow(
        title: specify['caption'],
        onTap: () {
          Provider.of<MapScreenHelper>(context, listen: false)
              .showDetails(context: context, documentSnapshot: specify);
        },
        snippet: specify['description'],
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection("posts").get().then((posts) {
      for (int i = 0; i < posts.docs.length; i++) {
        initMarker(specify: posts.docs[i], specifyId: posts.docs[i].id);
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
