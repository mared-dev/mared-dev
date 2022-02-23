import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/checkout/StripeCheckout.dart';
import 'package:mared_social/checkout/server_stub.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PromotePostHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor,
      title: Text(
        "Promote Post",
        style: TextStyle(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget listPosts(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: constantColors.blueGreyColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .collection("posts")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, postSnaps) {
          if (postSnaps.connectionState == ConnectionState.waiting) {
            return LoadingWidget(constantColors: constantColors);
          } else {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: ListView.builder(
                itemCount: postSnaps.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot postData = postSnaps.data!.docs[index];
                  return ListTile(
                    trailing: ElevatedButton(
                      onPressed: () {
                        promotionBottomSheet(context, size, postData);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "Promote",
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: postData['imageslist'][0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => SizedBox(
                          height: 50,
                          width: 50,
                          child: LoadingWidget(constantColors: constantColors),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      postData['caption'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      postData['description'],
                      style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> promotionBottomSheet(
      BuildContext context, Size size, DocumentSnapshot<Object?> postData) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, innerState) {
          return Container(
            height: size.height * 0.7,
            width: size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 30,
                          color: constantColors.blueColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "By promoting your post, you're agreeing to the terms and conditions of Mared. Your promoted post will be active for 30 Days. No refunds are applicable with promoted posts and upon inspection from Mared, if the post is found to be harmful to the user experience, Mared can take the necessary action against the post.",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: size.height * 0.3,
                    width: size.width,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: postData['imageslist'][index],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            );
                          },
                          itemCount: (postData['imageslist'] as List).length,
                          itemHeight: MediaQuery.of(context).size.height * 0.3,
                          itemWidth: MediaQuery.of(context).size.width,
                          layout: SwiperLayout.DEFAULT,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.date_range,
                          size: 30,
                          color: constantColors.blueColor,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Post promoted till ${DateTime.now().add(Duration(days: 30)).toString().substring(0, 10)}",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {
                            try {
                              makePayment(context: context, postData: postData);
                            } catch (e) {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                title: "Payment Failed",
                                text: e.toString(),
                              );
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.solidCreditCard,
                          ),
                          label: const Text("Promote Post"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  makePayment(
      {required BuildContext context,
      required DocumentSnapshot<Object?> postData}) async {
    final sessionID = await Server().createCheckout();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StripeCheckoutPage(
          sessionId: sessionID,
        ),
      ),
    );

    if (result.toString() != "cancel") {
      String bannerId = nanoid(14).toString();
      await Provider.of<FirebaseOperations>(context, listen: false)
          .createBannerCollection(context: context, bannerId: bannerId, data: {
        'bannerid': bannerId,
        'postid': postData['postid'],
        'imageslist': postData['imageslist'] as List,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
        'useruid':
            Provider.of<Authentication>(context, listen: false).getUserId,
        'time': Timestamp.now(),
        'useremail': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserEmail,
        'enddate':
            Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
      }).then((value) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: SplitPages(), type: PageTransitionType.rightToLeft));
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Post Promoted!",
            text:
                "Your post is now promoted till ${DateTime.now().add(Duration(days: 30)).toString().substring(0, 10)}");
      });
    }
  }
}
