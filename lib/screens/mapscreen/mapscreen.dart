import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor customIcon;

  void initMarker({required UserModel storeItem}) async {
    var markerIdVal = storeItem.uid;
    final MarkerId markerId = MarkerId(markerIdVal);

    GeoPoint geoPoint = storeItem.geoPoint;
    print('&&&&&&&&&&&&&&&');
    print(geoPoint.latitude);
    print(geoPoint.longitude);
    final Marker marker = Marker(
      markerId: markerId,
      icon: customIcon,
      position: LatLng(geoPoint.latitude, geoPoint.longitude),
      infoWindow: InfoWindow(
        title: 'Latest Post',
        onTap: () async {
          LoadingHelper.startLoading();
          var dynamicPost = await FirebaseFirestore.instance
              .collection("users")
              .doc(storeItem.uid)
              .collection("posts")
              .where('approvedForPosting', isEqualTo: true)
              .orderBy("time", descending: true)
              .limit(1)
              .get();

          LoadingHelper.endLoading();
          if (dynamicPost.docs.isNotEmpty) {
            pushNewScreen(context,
                screen: PostDetailsScreen(
                  documentSnapshot: dynamicPost.docs[0],
                  postId: dynamicPost.docs[0]['postid'],
                ));
          } else {
            pushNewScreen(context,
                screen: AltProfile(
                  userUid: storeItem.uid,
                  userModel: storeItem,
                ));
          }
        },
        // snippet: specify['description'],
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection("users")
        .where('store', isEqualTo: true)
        .get()
        .then((posts) {
      for (int i = 0; i < posts.docs.length; i++) {
        initMarker(storeItem: UserModel.fromJson(posts.docs[i]));
      }
    });
  }

  @override
  void initState() {
// make sure to initialize before map loading

    getBytesFromAsset('assets/icons/store_icon.png', 100).then((d) {
      customIcon = BitmapDescriptor.fromBytes(d);
      getMarkerData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context, title: 'MARED MAP'),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(
            25.2048,
            55.2708,
          ),
          zoom: 12,
        ),
        onMapCreated: (controller) {
          googleMapController = controller;
        },
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
