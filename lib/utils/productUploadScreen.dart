import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/config.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/general_styles.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/enums/post_type.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/services/mux/mux_video_stream.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
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
    _videoPlayerController.dispose();
  }

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.multipleImages[0].path));

    _videoPlayerController.initialize().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  TextEditingController captionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController adrController = TextEditingController();
  GooglePlace googlePlace =
      GooglePlace("AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI");

  String lat = "";
  String lng = "";
  String address = "";
  bool adrSelected = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  late UserModel userModel;
  var size;

  @override
  Widget build(BuildContext context) {
    List<String> catNames =
        Provider.of<FirebaseOperations>(context, listen: false).catNames;
    userModel = UserInfoManger.getUserInfo();
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: simpleAppBarWithBack(context,
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }, title: 'Add post', isTitleCentered: true),
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        bottom: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  _displayImagePart(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 26.h),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      textCapitalization: TextCapitalization.words,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: Colors.black,
                      decoration: getAuthInputDecoration(
                          hintText: 'Give your picture a title...',
                          backGroundColor: AppColors.addPostInputBackground),
                      controller: captionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    minLines: 3,
                    cursorColor: Colors.black,
                    decoration: getAuthInputDecoration(
                        hintText: "Give your picture a caption...",
                        backGroundColor: AppColors.addPostInputBackground),
                    controller: descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  _selectAddressLocation(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.commentButtonColor),
                          padding: EdgeInsets.symmetric(horizontal: 21.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/category_icon.svg'),
                              SizedBox(
                                width: 6.w,
                              ),
                              DropdownButton(
                                underline: SizedBox(),
                                dropdownColor: AppColors.backGroundColor,
                                hint: Container(
                                  margin: EdgeInsets.only(right: 6.w),
                                  alignment: Alignment.centerLeft,
                                  child: Text('choose a category',
                                      style: regularTextStyle(
                                          fontSize: 11,
                                          textColor:
                                              AppColors.backGroundColor)),
                                ),
                                value: _selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                icon: SvgPicture.asset(
                                    'assets/icons/select_category_arrow.svg'),
                                selectedItemBuilder: (context) {
                                  return catNames
                                      .map<Widget>((item) => Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(item,
                                                style: regularTextStyle(
                                                    fontSize: 11,
                                                    textColor: AppColors
                                                        .backGroundColor)),
                                          ))
                                      .toList();
                                },
                                items: catNames.map((category) {
                                  return DropdownMenuItem(
                                    child: Text(category,
                                        style: regularTextStyle(
                                            fontSize: 11,
                                            textColor:
                                                AppColors.commentButtonColor)),
                                    value: category,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            height: 35.h,
                            child: Opacity(
                              opacity: _canSharePost() ? 1 : 0.4,
                              child: ElevatedButton.icon(
                                icon: SvgPicture.asset(
                                    'assets/icons/share_icon.svg'),
                                label: Text(
                                  'Share',
                                  style: regularTextStyle(
                                      fontSize: 11,
                                      textColor: AppColors.backGroundColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 27.w, vertical: 6.h),
                                    primary: AppColors.commentButtonColor),
                                onPressed: _sharePost,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canSharePost() {
    return _selectedCategory != null &&
        _selectedCategory!.isNotEmpty &&
        captionController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  Widget _selectAddressLocation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: adrSelected == false,
          child: Padding(
            padding: const EdgeInsets.only(top: 26, bottom: 21),
            child: ElevatedButton.icon(
              icon: SvgPicture.asset('assets/icons/location_icon.svg'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                primary: AppColors.commentButtonColor,
              ),
              label: Text(
                "Select Location",
                style: regularTextStyle(
                    fontSize: 11, textColor: AppColors.backGroundColor),
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
                            google_maps_api.Component("country", "ae")
                          ],
                          apiKey: "AIzaSyCHjJlqqJ-eLChGmUX0RH2iJH5TtdU3RrI",
                          hintText: "Find a place ...",
                          searchingText: "Please wait ...",
                          selectText: "Select place",
                          outsideOfPickAreaText: "Place not in area",
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
        Visibility(
          visible: address.isNotEmpty && adrSelected == true,
          child: Container(
            padding: EdgeInsets.only(top: 26, bottom: 21),
            width: 330,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Selected Address: $address",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: semiBoldTextStyle(
                      textColor: AppColors.accentColor,
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
                    color: AppColors.commentButtonColor,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayImagePart() {
    return Container(
      height: 290.h,
      width: size.width,
      child: widget.postType == PostType.IMAGE
          ? CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 2,
                autoPlay: false,
                height: 290.h,
                enlargeCenterPage: false,
              ),
              items: widget.multipleImages.map((e) {
                return Image.file(
                  File(e.path),
                  // width: size.width - 40.w,
                  fit: BoxFit.cover,
                );
              }).toList(),
            )
          : _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    if (_videoPlayerController.value.isPlaying) {
                      _videoPlayerController.pause();
                    } else {
                      _videoPlayerController.play();
                    }
                  },
                  child: VideoPlayer(
                    _videoPlayerController,
                  ),
                )
              : LoadingWidget(constantColors: constantColors),
    );
  }

  _sharePost() async {
    //let's comment address and category and make them optional for now

    if (_selectedCategory!.isNotEmpty && _formKey.currentState!.validate()) {
      try {
        LoadingHelper.startLoading();
        String postId = nanoid(14).toString();
        String name = "${captionController.text} ${descriptionController.text}";

        List<String> splitList = name.split(" ");
        List<String> indexList = [];

        for (int i = 0; i < splitList.length; i++) {
          for (int j = 0; j < splitList[i].length; j++) {
            indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
          }
        }

        String videoStreamUrl = "";
        String playBackId = "";
        if (widget.postType == PostType.VIDEO) {
          playBackId = await getPlayBackId(widget.imagesList[0]);
          videoStreamUrl = getMuxVideoUrl(playBackId);
        }

        if (widget.postType == PostType.VIDEO && videoStreamUrl.isEmpty) {
          throw Exception();
        }

        await Provider.of<FirebaseOperations>(context, listen: false)
            .uploadPostData(postId, {
          'postid': postId,
          'approvedForPosting': false,
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
          'thumbnail': widget.postType == PostType.VIDEO
              ? getMuxThumbnailImage(playBackId)
              : "",
          'imageslist': (widget.postType == PostType.VIDEO)
              ? [videoStreamUrl]
              : widget.imagesList,
          'address': address,
          'lat': lat,
          'lng': lng,
        });

        FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .collection("posts")
            .doc(postId)
            .set({
          'postid': postId,
          'approvedForPosting': false,
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
          'thumbnail': widget.postType == PostType.VIDEO
              ? getMuxThumbnailImage(playBackId)
              : "",
          'address': address,
          'lat': lat,
          'lng': lng,
        });

        setState(() {
          widget.imagesList.clear();
          widget.multipleImages.clear();
        });
        Navigator.of(context).pop();
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         child: HomePage(),
        //         type: PageTransitionType.bottomToTop));
      } catch (e) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Error",
          text: "Please Check all fields",
        );
      } finally {
        LoadingHelper.endLoading();
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Error",
        text: "Please Check all fields",
      );
    }
  }
}
