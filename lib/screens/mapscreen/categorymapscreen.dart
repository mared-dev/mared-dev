import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/mapscreen/category_mapscreenhelper.dart';
import 'package:provider/provider.dart';

class CategoryMapScreen extends StatefulWidget {
  final String categoryName;

  const CategoryMapScreen({Key? key, required this.categoryName})
      : super(key: key);
  @override
  _CategoryMapScreenState createState() => _CategoryMapScreenState();
}

class _CategoryMapScreenState extends State<CategoryMapScreen> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  ConstantColors constantColors = ConstantColors();

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
          Provider.of<CategoryMapScreenHelper>(context, listen: false)
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
        if (posts.docs[i]['postcategory'] == widget.categoryName) {
          initMarker(specify: posts.docs[i], specifyId: posts.docs[i].id);
        }
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
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: constantColors.whiteColor,
            )),
        title: RichText(
          text: TextSpan(
            text: widget.categoryName,
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Map",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
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
