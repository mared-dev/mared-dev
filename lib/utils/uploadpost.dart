import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/models/enums/post_type.dart';
import 'package:mared_social/services/firebase/firebase_file_upload_service.dart';
import 'package:mared_social/utils/pick_files_helper.dart';
import 'package:mared_social/utils/productUploadCameraScreen.dart';
import 'package:mared_social/utils/productUploadScreen.dart';
import 'package:mared_social/widgets/bottom_sheets.dart';
import 'package:mared_social/widgets/bottom_sheets/confirm_post_image_video.dart';
import 'package:mared_social/widgets/reusable/bottom_sheet_top_divider.dart';
import 'package:mared_social/widgets/reusable/simple_button_icon.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_place_picker_mb/providers/place_provider.dart';
import 'package:google_maps_place_picker_mb/providers/search_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  late File uploadPostImage;
  late String uploadPostImageUrl;

  List<String> imagesList = [];
  List<XFile> multipleImages = [];

  XFile? _video;
  String _videoThumbnailUrl = "";

  File get getUploadPostImage => uploadPostImage;

  String get getUploadPostImageUrl => uploadPostImageUrl;

  late UploadTask imagePostUploadTask;

  //gallery or camera
  ImageSource _selectedSource = ImageSource.gallery;

  //post type is it a video or an image
  PostType _postType = PostType.IMAGE;

  late VideoPlayerController _videoPlayerController;

  //to select an image or video but change the name later
  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.commentButtonColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6))),
            child: Column(
              children: [
                BottomSheetTopDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SimpleButtonIcon(
                        buttonText: "Gallery",
                        buttonIcon: SvgPicture.asset(
                          'assets/icons/gallery_icon.svg',
                          width: 14,
                          height: 14,
                        ),
                        buttonCallback: () async {
                          _selectedSource = ImageSource.gallery;
                          if (_postType == PostType.IMAGE) {
                            multipleImages =
                                await PickFilesHelper.multiImagePicker();
                            if (multipleImages.isNotEmpty) {
                              confirmPostImageVideo(
                                  context: context, imageFiles: multipleImages);
                            }
                          } else {
                            _video = await PickFilesHelper.pickVide();
                            if (_video != null) {
                              _videoPlayerController =
                                  VideoPlayerController.file(
                                      File(_video!.path));

                              //START HERE
                              await _videoPlayerController.initialize();
                              _videoPlayerController.play();
                              previewStoryImage(
                                  video: _video,
                                  context: context,
                                  videoPlayerController: _videoPlayerController,
                                  onCompleteCallback: ({String? videoUrl}) {
                                    print('@@@@@@@@@@@@');
                                    print(videoUrl);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();

                                    pushNewScreen(
                                      context,
                                      screen: PostUploadScreen(
                                        multipleImages: [_video!],
                                        imagesList: [videoUrl!],
                                        postType: PostType.VIDEO,
                                      ),
                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  });
                              // Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         child: PostUploadScreen(
                              //           multipleImages: multipleImages,
                              //           imagesList: imagesList,
                              //         ),
                              //         type: PageTransitionType.bottomToTop));

                              // showPostCameraImage(context);
                            }
                          }
                        }),
                    SimpleButtonIcon(
                      buttonText: "Camera",
                      buttonIcon: SvgPicture.asset(
                        'assets/icons/camera_icon.svg',
                        width: 14,
                        height: 14,
                      ),
                      buttonCallback: () async {
                        _selectedSource = ImageSource.camera;
                        if (_postType == PostType.IMAGE) {
                          pickUploadPostImage(
                            context,
                            ImageSource.camera,
                          );
                        } else {
                          _video = await PickFilesHelper.pickVide(
                              source: ImageSource.camera);
                          if (_video != null) {
                            _videoPlayerController =
                                VideoPlayerController.file(File(_video!.path));

                            await _videoPlayerController.initialize();
                            _videoPlayerController.play();
                            previewStoryImage(
                                video: _video,
                                context: context,
                                videoPlayerController: _videoPlayerController,
                                onCompleteCallback: ({String? videoUrl}) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  pushNewScreen(
                                    context,
                                    screen: PostUploadScreen(
                                      multipleImages: [_video!],
                                      imagesList: [videoUrl!],
                                      postType: PostType.VIDEO,
                                    ),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  selectPostType(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.commentButtonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                BottomSheetTopDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SimpleButtonIcon(
                        buttonText: "Image",
                        buttonIcon: SvgPicture.asset(
                          'assets/icons/select_image_icon.svg',
                          width: 14,
                          height: 14,
                        ),
                        buttonCallback: () async {
                          _postType = PostType.IMAGE;
                          Navigator.of(context).pop();
                          selectPostImageType(context);
                        }),
                    SimpleButtonIcon(
                        buttonText: "Video",
                        buttonIcon: SvgPicture.asset(
                          'assets/icons/select_video_icon.svg',
                          width: 14,
                          height: 14,
                        ),
                        buttonCallback: () async {
                          _postType = PostType.VIDEO;
                          Navigator.of(context).pop();
                          selectPostImageType(context);
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //to pick and show the post with camera image
  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await PickFilesHelper.pickImage(source: source);
    uploadPostImageVal == null
        // ignore: avoid_print
        ? print("select image")
        : uploadPostImage = File(uploadPostImageVal.path);
    // ignore: avoid_print
    print(uploadPostImage.path);

    // ignore: unnecessary_null_comparison
    uploadPostImage != null
        ? showPostCameraImage(context)
        : print("Image upload error");

    print('111111111111111');
    Navigator.of(context).pop();
    confirmPostImageVideo(
        context: context, imageFiles: [XFile(uploadPostImage.path)]);
  }

  showPostCameraImage(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: _selectedSource == ImageSource.camera
                        ? Image.file(
                            uploadPostImage,
                            fit: BoxFit.contain,
                          )
                        : CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              height: MediaQuery.of(context).size.height,
                              viewportFraction: 2.0,
                              enlargeCenterPage: false,
                            ),
                            items: multipleImages.map((e) {
                              return Image.file(
                                File(e.path),
                              );
                            }).toList(),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        child: Text(
                          "Reselect",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),
                        ),
                        onPressed: () {
                          if (_postType == PostType.IMAGE)
                            selectPostImageType(context);
                        },
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Confirm Image",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          imagesList = await FirebaseFileUploadService
                              .uploadMultipleImagesToFirebase(
                                  multipleImages:
                                      _selectedSource == ImageSource.camera
                                          ? [XFile(uploadPostImage.path)]
                                          : multipleImages);

                          pushNewScreen(
                            context,
                            screen: PostUploadScreen(
                              multipleImages: multipleImages,
                              imagesList: imagesList,
                            ),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );

                          // editPostCameraSheet(context);
                          // print("image uploaded");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
