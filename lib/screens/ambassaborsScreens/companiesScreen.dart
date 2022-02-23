import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/ambassaborsScreens/previewVideo.dart';
import 'package:page_transition/page_transition.dart';

class CompaniesScreen extends StatefulWidget {
  @override
  _CompaniesScreenState createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  ConstantColors constantColors = ConstantColors();

  late File uploadVideo;

  final picker = ImagePicker();

  Future pickUploadPostVideo(
      {required BuildContext context,
      required ImageSource source,
      required DocumentSnapshot vendor}) async {
    final uploadVideoVal = await picker.pickVideo(source: source);
    uploadVideoVal == null
        // ignore: avoid_print
        ? print("select video")
        : uploadVideo = File(uploadVideoVal.path);
    // ignore: avoid_print
    print(uploadVideo.path);

    // ignore: unnecessary_null_comparison
    if (uploadVideo != null) {
      Navigator.push(
          context,
          PageTransition(
              child: PreviewAndSubmit(
                videoFile: uploadVideo,
                vendor: vendor,
              ),
              type: PageTransitionType.rightToLeft));
    } else {
      print("Image upload error");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: constantColors.blueGreyColor,
        title: Text(
          "Select Vendor",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("store", isEqualTo: true)
                .snapshots(),
            builder: (context, storeSnaps) {
              if (storeSnaps.connectionState == ConnectionState.waiting) {
                return LoadingWidget(constantColors: constantColors);
              } else {
                return ListView.builder(
                  itemCount: storeSnaps.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot storeData = storeSnaps.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        trailing: ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.pink),
                          ),
                          onPressed: () async {
                            pickUploadPostVideo(
                              context: context,
                              source: ImageSource.camera,
                              vendor: storeData,
                            );
                          },
                          icon: Icon(FontAwesomeIcons.video),
                          label: Text(
                            "Record",
                          ),
                        ),
                        leading: SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: storeData['userimage'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(
                          storeData['username'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
