import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/mapscreen/mapscreenhelper.dart';
import 'package:provider/provider.dart';

class AuctionProductMapScreen extends StatefulWidget {
  final dynamic docSnap;
  final String docSnapId;

  const AuctionProductMapScreen(
      {Key? key, required this.docSnap, required this.docSnapId})
      : super(key: key);
  @override
  _AuctionProductMapScreenState createState() =>
      _AuctionProductMapScreenState();
}

class _AuctionProductMapScreenState extends State<AuctionProductMapScreen> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    initMarker(specify: widget.docSnap, specifyId: widget.docSnapId);
    super.initState();
  }

  void initMarker({required dynamic specify, required String specifyId}) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(double.parse(specify['lat']), double.parse(specify['lng'])),
      infoWindow: InfoWindow(
        title: specify['title'],
        onTap: () {},
        snippet: specify['description'],
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text(
          "${widget.docSnap['title']}".capitalize(),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            color: constantColors.whiteColor,
            fontSize: 16,
          ),
        ),
      ),
      body: GoogleMap(
        buildingsEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.docSnap['lat']),
              double.parse(widget.docSnap['lng'])),
          zoom: 15,
        ),
        onMapCreated: (controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
