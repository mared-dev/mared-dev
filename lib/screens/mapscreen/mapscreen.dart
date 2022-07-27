import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/helpers/firebase_general_helpers.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/categories_list.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:mared_social/screens/mapscreen/map_filter_screen.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:mared_social/widgets/reusable/home_app_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../constants/text_styles.dart';
import '../../helpers/marker_with_text.dart';
import '../../models/category_model.dart';
import '../../services/firebase/firestore/FirebaseOpertaion.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor customIcon;
  List<CategoryModel> selectedCategories = [];

  @override
  void initState() {
// make sure to initialize before map loading

    getMarkerData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'MARED MAP',
            style: semiBoldTextStyle(
                fontSize: 20, textColor: AppColors.widgetsBackground),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/filter_icon.svg'),
              onPressed: () {
                // openFilterDelegate();
                pushNewScreen(
                  context,
                  screen: FilterPage(
                      selectedCategoryList: selectedCategories,
                      onApplySelected:
                          (List<CategoryModel> newSelectedCategories) async {
                        selectedCategories = newSelectedCategories;
                        if (selectedCategories.isEmpty) {
                          await getMarkerData();
                        } else {
                          await getMarkersDataForFilter();
                        }
                      }),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.slideRight,
                );
              },
            )
            // PopupMenuButton(
            //   offset: Offset(40, 60),
            //   elevation: 5.0,
            //   child: Container(
            //     margin: EdgeInsets.only(right: 20),
            //     width: 24,
            //     height: 24,
            //     child: Center(
            //       child: SvgPicture.asset(
            //         'assets/icons/filter_icon.svg',
            //         width: 24,
            //         height: 24,
            //       ),
            //     ),
            //   ),
            //   itemBuilder: (context) => categories.map((category) {
            //     return PopupMenuItem(
            //       child: StatefulBuilder(
            //         builder: (_context, _setState) => CheckboxListTile(
            //           activeColor: AppColors.accentColor,
            //           value: false,
            //           onChanged: (value) {},
            //           title: Text(category['categoryname']),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
          ]),
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

  void initMarker({required UserModel storeItem}) async {
    var markerIdVal = storeItem.uid;
    final MarkerId markerId = MarkerId(markerIdVal);
    print('!!!!!!!!!!!!!!!!!!');
    print(storeItem.userName);
    print(storeItem.postCategory);

    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)),
        categories[storeItem.postCategory.isEmpty
                ? 'Business & Industry'
                : storeItem.postCategory]!
            .markerIconText);
    GeoPoint geoPoint = storeItem.geoPoint;
    final Marker marker = Marker(
      markerId: markerId,
      icon: bitmapDescriptor,
      position: LatLng(geoPoint.latitude, geoPoint.longitude),
      infoWindow: InfoWindow(
        title: storeItem.userName,
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
        .then((users) {
      for (int i = 0; i < users.docs.length; i++) {
        initMarker(storeItem: UserModel.fromJson(users.docs[i]));
      }
    });
  }

  getMarkersDataForFilter() {
    List<String> categoriesNames =
        selectedCategories.map<String>((e) => e.categoryName).toList();
    FirebaseFirestore.instance
        .collection('users')
        .where('store', isEqualTo: true)
        .where("postcategory", whereIn: categoriesNames)
        .get()
        .then((posts) {
      markers.clear();
      if (posts.docs.isEmpty) {
        setState(() {});
      } else {
        for (int i = 0; i < posts.docs.length; i++) {
          print('----------------------');
          print(i);
          initMarker(storeItem: UserModel.fromJson(posts.docs[i]));
        }
      }
    });
    setState(() {});
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    //Draws string representation of svg to DrawableRoot
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');
    ui.Picture picture = svgDrawableRoot.toPicture();
    ui.Image image = await picture.toImage(26, 37);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
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
