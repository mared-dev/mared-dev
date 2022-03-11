import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/config.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/enums/post_type.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/mux/mux_video_stream.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_api;
import 'package:video_player/video_player.dart';

//this is the form you fill to upload a post

class PostUploadScreen extends StatefulWidget {
  late List<String> imagesList;
  final List<XFile> multipleImages;
  final PostType postType;

  PostUploadScreen(
      {Key? key,
      required this.imagesList,
      required this.multipleImages,
      this.postType = PostType.IMAGE})
      : super(key: key);

  @override
  _PostUploadScreenState createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  ConstantColors constantColors = ConstantColors();

  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  PickResult? selectedPlace;

  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.multipleImages[0].path));

    _videoPlayerController.initialize();
    super.initState();
  }

  TextEditingController captionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController adrController = TextEditingController();
  GooglePlace googlePlace =
      GooglePlace("AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI");

  late String lat;
  late String lng;
  String address = "";
  bool adrSelected = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    List<String> catNames =
        Provider.of<FirebaseOperations>(context, listen: false).catNames;
    userModel = UserInfoManger.getUserInfo();
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image_aspect_ratio,
                                  color: constantColors.greenColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.fit_screen,
                                  color: constantColors.yellowColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          width: 300,
                          child: widget.postType == PostType.IMAGE
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    height: MediaQuery.of(context).size.height,
                                    viewportFraction: 2.0,
                                    enlargeCenterPage: false,
                                  ),
                                  items: widget.multipleImages.map((e) {
                                    return Image.file(
                                      File(e.path),
                                    );
                                  }).toList(),
                                )
                              : _videoPlayerController.value.isInitialized
                                  ? VideoPlayer(
                                      _videoPlayerController,
                                    )
                                  : LoadingWidget(
                                      constantColors: constantColors),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 50,
                              width: 330,
                              child: TextFormField(
                                validator: (value) => value!.isEmpty
                                    ? "Title cannot be empty"
                                    : null,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                maxLength: 50,
                                controller: captionController,
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Give your picture a title...",
                                  hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            height: 120,
                            width: 330,
                            child: TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? "Caption cannot be empty"
                                  : null,
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(200)
                              ],
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              maxLength: 200,
                              controller: descriptionController,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: "Give your picture a caption...",
                                hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: adrSelected == false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 16, top: 16, bottom: 16),
                      child: SizedBox(
                        height: 50,
                        width: 330,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.pink),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined),
                              Text("Select Location"),
                            ],
                          ),
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Container(
                                    color: constantColors.whiteColor,
                                    child: PlacePicker(
                                      autocompleteComponents: [
                                        google_maps_api.Component(
                                            "country", "ae")
                                      ],
                                      apiKey:
                                          "AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI",
                                      hintText: "Find a place ...",
                                      searchingText: "Please wait ...",
                                      selectText: "Select place",
                                      outsideOfPickAreaText:
                                          "Place not in area",
                                      initialPosition: LatLng(25.2048, 55.2708),
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      usePinPointingSearch: true,
                                      usePlaceDetailSearch: true,
                                      onPlacePicked: (result) {
                                        selectedPlace = result;

                                        Navigator.pop(context, {
                                          "address": result.formattedAddress,
                                          "lat": result.geometry!.location.lat,
                                          "lng": result.geometry!.location.lng
                                        });
                                      },
                                      automaticallyImplyAppBarLeading: false,
                                      region: 'ae',
                                    ),
                                  );
                                },
                              ),
                            );

                            if (result['address'].toString().isNotEmpty) {
                              setState(() {
                                adrSelected = true;
                                address = result['address'].toString();
                                lat = result['lat'].toString();
                                lng = result['lng'].toString();
                              });
                            } else {
                              setState(() {
                                adrSelected = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: address.isNotEmpty && adrSelected == true,
                    child: SizedBox(
                      height: 50,
                      width: 330,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Selected Address: $address",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: constantColors.greenColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                address = "";
                                adrSelected = false;
                              });
                              adrController.clear();
                            },
                            icon: Icon(
                              Icons.edit,
                              color: constantColors.redColor,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DropdownButton(
                                dropdownColor: constantColors.blueGreyColor,
                                hint: Text(
                                  'Please choose a Category',
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                  ),
                                ),
                                value: _selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                items: catNames.map((category) {
                                  return DropdownMenuItem(
                                    child: Text(category,
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    value: category,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Text(
                      "Share",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      //let's comment address and category and make them optional for now

                      if (_formKey.currentState!.validate()) {
                        try {
                          String postId = nanoid(14).toString();
                          String name =
                              "${captionController.text} ${descriptionController.text}";

                          List<String> splitList = name.split(" ");
                          List<String> indexList = [];

                          for (int i = 0; i < splitList.length; i++) {
                            for (int j = 0; j < splitList[i].length; j++) {
                              indexList.add(splitList[i]
                                  .substring(0, j + 1)
                                  .toLowerCase());
                            }
                          }

                          String videoStreamUrl = "";
                          if (widget.postType == PostType.VIDEO) {
                            videoStreamUrl =
                                await uploadVideoToMux(widget.imagesList[0]);
                          }

                          if (widget.postType == PostType.VIDEO &&
                              videoStreamUrl.isEmpty) {
                            throw Exception();
                          }

                          await Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .uploadPostData(postId, {
                            'postid': postId,
                            'searchindex': indexList,
                            'likes': [],
                            'comments': [],
                            'postcategory': _selectedCategory,
                            'caption': captionController.text,
                            'username': userModel.userName,
                            'userimage': userModel.photoUrl,
                            'useruid': userModel.uid,
                            'time': Timestamp.now(),
                            'useremail': userModel.email,
                            'description': descriptionController.text,
                            'imageslist': (widget.postType == PostType.VIDEO)
                                ? [videoStreamUrl]
                                : widget.imagesList,
                            'address': address,
                            'lat': lat,
                            'lng': lng,
                          });

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId)
                              .collection("posts")
                              .doc(postId)
                              .set({
                            'postid': postId,
                            'likes': [],
                            'comments': [],
                            'searchindex': indexList,
                            'postcategory': _selectedCategory,
                            'caption': captionController.text,
                            'username': userModel.userName,
                            'userimage': userModel.photoUrl,
                            'useruid': userModel.uid,
                            'time': Timestamp.now(),
                            'useremail': userModel.email,
                            'description': descriptionController.text,
                            'imageslist': (widget.postType == PostType.VIDEO)
                                ? [videoStreamUrl]
                                : widget.imagesList,
                            'address': address,
                            'lat': lat,
                            'lng': lng,
                          });

                          setState(() {
                            widget.imagesList.clear();
                            widget.multipleImages.clear();
                          });
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SplitPages(),
                                  type: PageTransitionType.bottomToTop));
                        } catch (e) {
                          print('@@@@@@@@@@@@@@error@@@@@@@@@@@@@@@@@@@');
                          print(e);
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Error",
                            text: "Please Check all fields",
                          );
                        }
                      } else {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Error",
                          text: "Please Check all fields",
                        );
                      }
                    },
                    color: constantColors.blueColor,
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
