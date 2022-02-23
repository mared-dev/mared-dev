import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Messaging/privateMessage.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AltProfileHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_sharp,
          color: constantColors.whiteColor,
        ),
      ),
      backgroundColor: constantColors.blueGreyColor,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
            text: "The",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Mared",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ]),
      ),
    );
  }

  Widget headerProfile(
      {required BuildContext context,
      required AsyncSnapshot<DocumentSnapshot> userDocSnap,
      required String userUid}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.34,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 220,
                width: 180,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: userDocSnap.data!['userimage'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => SizedBox(
                              height: 50,
                              width: 50,
                              child:
                                  LoadingWidget(constantColors: constantColors),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          userDocSnap.data!['username'],
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              EvaIcons.email,
                              color: constantColors.greenColor,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                userDocSnap.data!['useremail'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: userDocSnap.data!['store'],
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.storeAlt,
                                color: constantColors.blueColor,
                                size: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Store Profile",
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              checkFollowerSheet(
                                  context: context, userDocSnap: userDocSnap);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userDocSnap.data!['useruid'])
                                          .collection("followers")
                                          .snapshots(),
                                      builder: (context, followerSnap) {
                                        if (followerSnap.hasData) {
                                          return Text(
                                            followerSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            "0",
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          );
                                        }
                                      }),
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              checkFollowingSheet(
                                  context: context, userDocSnap: userDocSnap);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 80,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userDocSnap.data!['useruid'])
                                          .collection("following")
                                          .snapshots(),
                                      builder: (context, followingSnap) {
                                        if (followingSnap.hasData) {
                                          return Text(
                                            followingSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            "0",
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          );
                                        }
                                      }),
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 70,
                        width: 80,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(userDocSnap.data!['useruid'])
                                .collection("posts")
                                .snapshots(),
                            builder: (context, userPostSnaps) {
                              if (!userPostSnaps.hasData) {
                                return Column(
                                  children: [
                                    Text(
                                      "0",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      "Posts",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      userPostSnaps.data!.docs.length
                                          .toString(),
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      "Posts",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userDocSnap.data!['useruid'])
                  .collection("followers")
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.data!.exists) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Follow",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .getIsAnon ==
                                false) {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .followUser(
                                followingUid: userUid,
                                followingDocId: Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                    .getUserId,
                                followingData: {
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserName,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserImage,
                                  'useremail': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getInitUserEmail,
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserId,
                                  'time': Timestamp.now(),
                                },
                                followerUid: Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                    .getUserId,
                                followerDocId: userUid,
                                followerData: {
                                  'username': userDocSnap.data!['username'],
                                  'userimage': userDocSnap.data!['userimage'],
                                  'useremail': userDocSnap.data!['useremail'],
                                  'useruid': userDocSnap.data!['useruid'],
                                  'time': Timestamp.now(),
                                },
                              )
                                  .whenComplete(() {
                                followedNotification(
                                    context: context,
                                    name: userDocSnap.data!['username']);
                              });
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Message",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .getIsAnon ==
                                false) {
                              await Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .messageUser(
                                      messagingUid: userUid,
                                      messagingDocId:
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId,
                                      messagingData: {
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
                                        'useremail':
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getInitUserEmail,
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserId,
                                        'time': Timestamp.now(),
                                      },
                                      messengerUid: Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                      messengerDocId: userUid,
                                      messengerData: {
                                        'username':
                                            userDocSnap.data!['username'],
                                        'userimage':
                                            userDocSnap.data!['userimage'],
                                        'useremail':
                                            userDocSnap.data!['useremail'],
                                        'useruid': userDocSnap.data!['useruid'],
                                        'time': Timestamp.now(),
                                      })
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: PrivateMessage(
                                          documentSnapshot: (userDocSnap.data
                                              as DocumentSnapshot)),
                                      type: PageTransitionType.leftToRight),
                                );
                              });
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Unfollow",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .unfollowUser(
                              followingUid: userUid,
                              followingDocId: Provider.of<Authentication>(
                                      context,
                                      listen: false)
                                  .getUserId,
                              followerUid: Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                              followerDocId: userUid,
                            )
                                .whenComplete(() {
                              unfollowedNotification(
                                  context: context,
                                  name: userDocSnap.data!['username']);
                            });
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Message",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            if (Provider.of<Authentication>(context,
                                        listen: false)
                                    .getIsAnon ==
                                false) {
                              await Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .messageUser(
                                      messagingUid: userUid,
                                      messagingDocId:
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId,
                                      messagingData: {
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
                                        'useremail':
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getInitUserEmail,
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserId,
                                        'time': Timestamp.now(),
                                      },
                                      messengerUid: Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserId,
                                      messengerDocId: userUid,
                                      messengerData: {
                                        'username':
                                            userDocSnap.data!['username'],
                                        'userimage':
                                            userDocSnap.data!['userimage'],
                                        'useremail':
                                            userDocSnap.data!['useremail'],
                                        'useruid': userDocSnap.data!['useruid'],
                                        'time': Timestamp.now(),
                                      })
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: PrivateMessage(
                                            documentSnapshot: (userDocSnap.data
                                                as DocumentSnapshot)),
                                        type: PageTransitionType.leftToRight));
                              });
                            } else {
                              Provider.of<FeedHelpers>(context, listen: false)
                                  .IsAnonBottomSheet(context);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: constantColors.whiteColor.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget middleProfile(
      {required BuildContext context,
      required AsyncSnapshot<DocumentSnapshot<Object?>> snapshot}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      FontAwesomeIcons.userAstronaut,
                      color: constantColors.yellowColor,
                      size: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      snapshot.data!['store'] == false
                          ? "Recently Added"
                          : "Mared Ambassador Promotions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: snapshot.data!['store'] == false
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(snapshot.data!.id)
                        .collection("following")
                        .snapshots(),
                    builder: (context, followingSnap) {
                      if (followingSnap.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              followingSnap.data!.docs.map((followingDocSnap) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: followingDocSnap['userimage'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            LoadingWidget(
                                                constantColors: constantColors),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No Recent Followers",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        );
                      }
                    })
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(snapshot.data!.id)
                        .collection("submittedWork")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, followingSnap) {
                      if (followingSnap.hasData) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              followingSnap.data!.docs.map((followingDocSnap) {
                            return followingDocSnap['approved']
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: SeeVideo(
                                                  documentSnapshot:
                                                      followingDocSnap),
                                              type: PageTransitionType
                                                  .bottomToTop));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                followingDocSnap['thumbnail'],
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                LoadingWidget(
                                                    constantColors:
                                                        constantColors),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                          }).toList(),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No Ambassador Promotions",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        );
                      }
                    }),
          ),
        ],
      ),
    );
  }

  Widget footerProfile(
      {required BuildContext context,
      dynamic snapshot,
      required String userUid}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .collection("posts")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, userPostSnap) {
          if (!userPostSnap.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset("assets/images/empty.png"),
                      height: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No posts yet",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: constantColors.darkColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                children: userPostSnap.data!.docs.map((userPostDocSnap) {
                  return InkWell(
                    onTap: () {
                      showPostDetail(
                        context: context,
                        documentSnapshot: userPostDocSnap,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: userPostDocSnap['imageslist'][index],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: LoadingWidget(
                                      constantColors: constantColors),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              );
                            },
                            itemCount:
                                (userPostDocSnap['imageslist'] as List).length,
                            itemHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            itemWidth: MediaQuery.of(context).size.width,
                            layout: SwiperLayout.DEFAULT,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        });
  }

  followedNotification({required BuildContext context, required String name}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    "Followed $name",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  unfollowedNotification(
      {required BuildContext context, required String name}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    "Unfollowed $name",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  checkFollowingSheet(
      {required BuildContext context, required dynamic userDocSnap}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userDocSnap.data!['useruid'])
                    .collection("following")
                    .snapshots(),
                builder: (context, followingSnap) {
                  if (followingSnap.hasData) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: constantColors.whiteColor,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Following",
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            children: followingSnap.data!.docs
                                .map((followingDocSnap) {
                              return ListTile(
                                onTap: () {
                                  if (followingDocSnap['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  followingDocSnap['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                leading: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: followingDocSnap['userimage'],
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
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
                                ),
                                title: Text(
                                  followingDocSnap['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  followingDocSnap['useremail'],
                                  style: TextStyle(
                                    color: constantColors.yellowColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      "${userDocSnap.data!['useruid']} is not following anyone",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  checkFollowerSheet(
      {required BuildContext context, required dynamic userDocSnap}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userDocSnap.data!['useruid'])
                    .collection("followers")
                    .snapshots(),
                builder: (context, followerSnap) {
                  if (followerSnap.hasData) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: constantColors.whiteColor,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Followers",
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            children:
                                followerSnap.data!.docs.map((followerDocSnap) {
                              return ListTile(
                                onTap: () {
                                  if (followerDocSnap['useruid'] !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: AltProfile(
                                              userUid:
                                                  followerDocSnap['useruid'],
                                            ),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  }
                                },
                                leading: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: followerDocSnap['userimage'],
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                SizedBox(
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
                                ),
                                title: Text(
                                  followerDocSnap['username'],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  followerDocSnap['useremail'],
                                  style: TextStyle(
                                    color: constantColors.yellowColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      "${userDocSnap.data!['useruid']} is not following anyone",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    );
                  }
                }),
          ),
        );
      },
    );
  }

  showPostDetail({
    required BuildContext context,
    required DocumentSnapshot documentSnapshot,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
                InkWell(
                  onDoubleTap: () {
                    if (Provider.of<Authentication>(context, listen: false)
                            .getIsAnon ==
                        false) {
                      Provider.of<PostFunctions>(context, listen: false)
                          .addLike(
                        userUid: documentSnapshot['useruid'],
                        context: context,
                        postID: documentSnapshot['postid'],
                        subDocId:
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                      );
                    } else {
                      Provider.of<FeedHelpers>(context, listen: false)
                          .IsAnonBottomSheet(context);
                    }
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          fit: BoxFit.contain,
                          imageUrl: documentSnapshot['imageslist'][index],
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 50,
                            width: 50,
                            child:
                                LoadingWidget(constantColors: constantColors),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                      itemCount:
                          (documentSnapshot['imageslist'] as List).length,
                      itemHeight: MediaQuery.of(context).size.height * 0.3,
                      itemWidth: MediaQuery.of(context).size.width,
                      layout: SwiperLayout.DEFAULT,
                      indicatorLayout: PageIndicatorLayout.SCALE,
                      pagination: SwiperPagination(
                        margin: EdgeInsets.all(10),
                        builder: DotSwiperPaginationBuilder(
                          color: constantColors.whiteColor.withOpacity(0.6),
                          activeColor:
                              constantColors.darkColor.withOpacity(0.6),
                          size: 15,
                          activeSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      documentSnapshot['description'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showLikes(
                                      context: context,
                                      postId: documentSnapshot['postid']);
                            },
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .doc(documentSnapshot['postid'])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context, likeSnap) {
                                  return SizedBox(
                                    width: 60,
                                    height: 50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            likeSnap.data!.docs.any((element) =>
                                                    element.id ==
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserId)
                                                ? EvaIcons.heart
                                                : EvaIcons.heartOutline,
                                            color: constantColors.redColor,
                                            size: 18,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              likeSnap.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showCommentsSheet(
                                      snapshot: documentSnapshot,
                                      context: context,
                                      postId: documentSnapshot['postid']);
                            },
                            child: SizedBox(
                              width: 60,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.comment,
                                      color: constantColors.blueColor,
                                      size: 16,
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("posts")
                                          .doc(documentSnapshot['postid'])
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, commentSnap) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            commentSnap.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showRewards(
                                      context: context,
                                      postId: documentSnapshot['postid']);
                            },
                            child: SizedBox(
                              width: 60,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.award,
                                      color: constantColors.yellowColor,
                                      size: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("posts")
                                            .doc(documentSnapshot['postid'])
                                            .collection('awards')
                                            .snapshots(),
                                        builder: (context, awardSnap) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              awardSnap.data!.docs.length
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Provider.of<Authentication>(context, listen: false)
                                      .getUserId ==
                                  documentSnapshot['useruid']
                              ? IconButton(
                                  onPressed: () {
                                    Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .showPostOptions(
                                            context: context,
                                            postId: documentSnapshot['postid']);

                                    Provider.of<PostFunctions>(context,
                                            listen: false)
                                        .getImageDescription(
                                            documentSnapshot['description']);
                                  },
                                  icon: Icon(EvaIcons.moreVertical,
                                      color: constantColors.whiteColor),
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                        ],
                      ),
                    ),
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
