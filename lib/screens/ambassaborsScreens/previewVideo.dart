import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/ambassaborsScreens/previewVideoHelper.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/services/fcm_notification_Service.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PreviewAndSubmit extends StatefulWidget {
  final File videoFile;
  final DocumentSnapshot vendor;

  const PreviewAndSubmit({
    Key? key,
    required this.videoFile,
    required this.vendor,
  }) : super(key: key);
  @override
  _PreviewAndSubmitState createState() => _PreviewAndSubmitState();
}

class _PreviewAndSubmitState extends State<PreviewAndSubmit> {
  late UploadTask imagePostUploadTask;
  late String uploadPostImageUrl;

  ConstantColors constantColors = ConstantColors();
  VideoPlayerController? _videoPlayerController;
  File? thumbnailFile;

  final descriptionController = TextEditingController();
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  late Size screenSize;
  late var widthSize;
  late var heightSize;

  late UploadTask videoUploadTask;
  late String videoUrl;

  Future uploadStoryVideo(
      {required BuildContext context, required File videoFile}) async {
    Reference videoRef = FirebaseStorage.instance
        .ref()
        .child('stories/${videoFile.path}/${Timestamp.now()}');

    videoUploadTask = videoRef.putFile(
        File(videoFile.path), SettableMetadata(contentType: 'video/mp4'));

    await videoUploadTask.whenComplete(() {
      print("video uploaded");
    });
    await videoRef.getDownloadURL().then((url) {
      setState(() {
        videoUrl = url;
      });
    });
  }

  Future uploadPostCameraImageToFirebase(
      {required File uploadPostImage}) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print("Post image uploaded to storage");
    });
    imageReference.getDownloadURL().then((imageUrl) {
      setState(() {
        uploadPostImageUrl = imageUrl;
      });
    });
  }

  final picker = ImagePicker();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    if (uploadPostImageVal == null) {
      print("select image");
    } else {
      setState(() {
        thumbnailFile = File(uploadPostImageVal.path);
      });
    }

    // ignore: avoid_print
    print(thumbnailFile!.path);
  }

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoFile.path));

    // ignore: avoid_single_cascade_in_expression_statements
    _videoPlayerController!
      ..initialize().then((value) {
        _videoPlayerController!.setLooping(true);
        setState(() {
          screenSize = _videoPlayerController!.value.size;
          widthSize = screenSize.width;
          heightSize = screenSize.height;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text("Preview and Upload"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.5,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    height: heightSize,
                    width: widthSize,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: _videoPlayerController!.value.isInitialized
                          ? VideoPlayer(
                              _videoPlayerController!,
                            )
                          : LoadingWidget(constantColors: constantColors),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.pink),
                        ),
                        onPressed: () {
                          setState(() {
                            _videoPlayerController!.value.isPlaying
                                ? _videoPlayerController!.pause()
                                : _videoPlayerController!.play();
                          });
                        },
                        icon: _videoPlayerController!.value.isPlaying
                            ? Icon(FontAwesomeIcons.pauseCircle)
                            : Icon(FontAwesomeIcons.playCircle),
                        label: Text(
                          _videoPlayerController!.value.isPlaying
                              ? "Pause"
                              : "Play",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.pink),
                        ),
                        onPressed: () {
                          _videoPlayerController!.seekTo(Duration(seconds: 0));
                        },
                        icon: Icon(FontAwesomeIcons.redoAlt),
                        label: Text(
                          "Replay",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: constantColors.lightColor,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Assign Thumbnail",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onDoubleTap: () {
                          setState(() {
                            thumbnailFile = null;
                          });
                        },
                        onTap: () async {},
                        child: SizedBox(
                          height: thumbnailFile != null
                              ? size.height * 0.3
                              : size.height * 0.05,
                          child: thumbnailFile != null
                              ? Image.file(
                                  thumbnailFile!,
                                  fit: BoxFit.contain,
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          pickUploadPostImage(
                                              context, ImageSource.camera);
                                        },
                                        icon: Icon(Icons.camera),
                                        label: Text("Camera"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          pickUploadPostImage(
                                              context, ImageSource.gallery);
                                        },
                                        icon: Icon(Icons.photo_album),
                                        label: Text("Gallery"),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        child: TextFormField(
                          validator: (value) => value!.isEmpty
                              ? "Description cannot be empty"
                              : null,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 300,
                          controller: descriptionController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.pink,
                                width: 2.0,
                              ),
                            ),
                            hintText: "Describe your experience ...",
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.pink),
                              ),
                              onPressed: () async {
                                try {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.loading);

                                  await uploadPostCameraImageToFirebase(
                                          uploadPostImage: thumbnailFile!)
                                      .whenComplete(() async {
                                    await uploadStoryVideo(
                                            context: context,
                                            videoFile: widget.videoFile)
                                        .whenComplete(() async {
                                      String workId = nanoid(14).toString();

                                      await Provider.of<FirebaseOperations>(
                                              context,
                                              listen: false)
                                          .uploadAmbassadorWork(
                                        context: context,
                                        vendorData: widget.vendor,
                                        inUserDB: {
                                          'vendorname':
                                              widget.vendor['username'],
                                          'vendoremail':
                                              widget.vendor['useremail'],
                                          'vendorid': widget.vendor['useruid'],
                                          'vendorimage':
                                              widget.vendor['userimage'],
                                          'wokrid': workId,
                                          'description':
                                              descriptionController.text,
                                          'username':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserName,
                                          'userimage':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserImage,
                                          'useruid':
                                              Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserId,
                                          'time': Timestamp.now(),
                                          'useremail':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getInitUserEmail,
                                          'fcmToken':
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .getFcmToken,
                                          'thumbnail': uploadPostImageUrl,
                                          'approved': false,
                                          'video': videoUrl,
                                        },
                                        workId: workId,
                                      )
                                          .whenComplete(() async {
                                        await _fcmNotificationService
                                            .sendNotificationToUser(
                                                to: widget.vendor[
                                                    'fcmToken'], //To change once set up
                                                title:
                                                    "${Provider.of<FirebaseOperations>(context, listen: false).getInitUserName} created a brand video for you",
                                                body:
                                                    "you have a new brand video. If you like it, approve it to show all your users!");

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    });
                                  });
                                } catch (e) {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      title: "Upload Error",
                                      text: "${e.toString()}");
                                }
                              },
                              icon: Icon(FontAwesomeIcons.video),
                              label: Text(
                                "Post",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
