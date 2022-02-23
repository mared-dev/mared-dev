// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/screens/ambassaborsScreens/companiesScreen.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  Widget headerProfile(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Row(
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
                  GestureDetector(
                    onTap: () {
                      postSelectType(context: context);
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: snapshot.data!['userimage'],
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  LoadingWidget(constantColors: constantColors),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Icon(
                            FontAwesomeIcons.plusCircle,
                            color: constantColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      snapshot.data!['username'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data!['useremail'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .store,
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
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                            context: context,
                            userDocSnap: snapshot,
                          );
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
                                      .doc(snapshot.data!['useruid'])
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
                            context: context,
                            userDocSnap: snapshot,
                          );
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
                                      .doc(snapshot.data!['useruid'])
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
                            .doc(snapshot.data!['useruid'])
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
                                  userPostSnaps.data!.docs.length.toString(),
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

  Widget profileNavBar(
      {required BuildContext context,
      required int index,
      required PageController pageController}) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.greenColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.1,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(
          index,
        );
        notifyListeners();
      },
      backgroundColor: constantColors.transperant,
      items: [
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.idBadge)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.gavel)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.streetView)),
      ],
    );
  }

  Widget storeProfileNavBar(
      {required BuildContext context,
      required int index,
      required PageController pageController}) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.greenColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.1,
      iconSize: 30,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(
          index,
        );
        notifyListeners();
      },
      backgroundColor: constantColors.transperant,
      items: [
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.idBadge)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.gavel)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.streetView)),
        CustomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.networkWired)),
      ],
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, left: 0),
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
                      Provider.of<FirebaseOperations>(context, listen: false)
                                  .store ==
                              false
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
            child: Provider.of<FirebaseOperations>(context, listen: false)
                        .store ==
                    false
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(snapshot.data!['useruid'])
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
                        .doc(snapshot.data!['useruid'])
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

  logOutDialog(BuildContext context) {
    return CoolAlert.show(
      context: context,
      backgroundColor: constantColors.darkColor,
      type: CoolAlertType.info,
      showCancelBtn: true,
      title: "Are you sure you want to log out?",
      confirmBtnText: "Log Out",
      onConfirmBtnTap: () {
        Provider.of<Authentication>(context, listen: false).signOutWithGoogle();
        Provider.of<Authentication>(context, listen: false)
            .logOutViaEmail()
            .whenComplete(() {
          Navigator.pushReplacement(
            context,
            PageTransition(
                child: LandingPage(), type: PageTransitionType.topToBottom),
          );
        });
      },
      confirmBtnTextStyle: TextStyle(
        color: constantColors.whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      cancelBtnText: "No",
      cancelBtnTextStyle: TextStyle(
        color: constantColors.redColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        decoration: TextDecoration.underline,
        decorationColor: constantColors.redColor,
      ),
      onCancelBtnTap: () => Navigator.pop(context),
    );
  }

  postSelectType({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            constantColors.blueColor),
                      ),
                      onPressed: () {
                        Provider.of<UploadPost>(context, listen: false)
                            .selectPostImageType(context);
                      },
                      icon: Icon(
                        EvaIcons.plusSquareOutline,
                        color: constantColors.whiteColor,
                      ),
                      label: Text(
                        "Add A Post",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            constantColors.blueColor),
                      ),
                      onPressed: () {
                        storyWidgets.addStory(context: context);
                      },
                      icon: Icon(
                        EvaIcons.videoOutline,
                        color: constantColors.whiteColor,
                      ),
                      label: Text(
                        "Add A Story",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid:
                                                followingDocSnap['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                                trailing: MaterialButton(
                                  color: constantColors.blueColor,
                                  child: Text(
                                    "Unfollow",
                                    style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
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
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            LoadingWidget(
                                                constantColors: constantColors),
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
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: followerDocSnap['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
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
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            LoadingWidget(
                                                constantColors: constantColors),
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

  showPostDetail(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot}) {
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
                Text(
                  documentSnapshot['description'],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

class PostsProfile extends StatelessWidget {
  const PostsProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: UserSettingsPage(),
                    type: PageTransitionType.leftToRight));
          },
          icon: Icon(
            FontAwesomeIcons.cogs,
            color: constantColors.greenColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "My ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Profile",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.darkColor,
        onPressed: () {
          Provider.of<ProfileHelpers>(context, listen: false)
              .postSelectType(context: context);
        },
        child: Stack(
          children: [
            Center(
              child: Icon(
                EvaIcons.plusCircleOutline,
                color: constantColors.whiteColor,
              ),
            ),
            Lottie.asset("assets/animations/cool.json"),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.43,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .headerProfile(context, snapshot),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .divider(),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .middleProfile(context, snapshot),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserId)
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, userPostSnap) {
              return SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.toInt() < userPostSnap.data!.docs.length) {
                        var userPostDocSnap = userPostSnap.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Provider.of<ProfileHelpers>(context, listen: false)
                                .showPostDetail(
                                    context: context,
                                    documentSnapshot: userPostDocSnap);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userPostDocSnap['imageslist']
                                          [index],
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
                                      (userPostDocSnap['imageslist'] as List)
                                          .length,
                                  itemHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  itemWidth: MediaQuery.of(context).size.width,
                                  layout: SwiperLayout.DEFAULT,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AuctionsProfile extends StatelessWidget {
  const AuctionsProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "My ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Auctions",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: constantColors.darkColor,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: CreateAuctionScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        label: Text(
          "Post Auction",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        icon: Lottie.asset(
          "assets/animations/gavel.json",
          height: 20,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.43,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .headerProfile(context, snapshot),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .divider(),
                          Provider.of<ProfileHelpers>(context, listen: false)
                              .middleProfile(context, snapshot),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserId)
                .collection("auctions")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, userAuctionSnap) {
              return SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.toInt() < userAuctionSnap.data!.docs.length) {
                        var userAuctionDocSnap =
                            userAuctionSnap.data!.docs[index];

                        bool dateCheck = DateTime.now().isBefore(
                            (userAuctionDocSnap['enddate'] as Timestamp)
                                .toDate());
                        return InkWell(
                          onTap: () {
                            Provider.of<AuctionMapHelper>(context,
                                    listen: false)
                                .showAuctionDetails(
                                    context: context,
                                    documentSnapshot: userAuctionDocSnap);
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Swiper(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              userAuctionDocSnap['imageslist']
                                                  [index],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                          (userAuctionDocSnap['imageslist']
                                                  as List)
                                              .length,
                                      itemHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      itemWidth:
                                          MediaQuery.of(context).size.width,
                                      layout: SwiperLayout.DEFAULT,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: dateCheck,
                                replacement: Container(
                                  height: size.height,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: constantColors.greyColor
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Auction Over",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Positioned(
                                  top: 5,
                                  right: 5,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Lottie.asset(
                                      "assets/animations/gavel.json",
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AmbassadorProfile extends StatelessWidget {
  const AmbassadorProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Ambassador",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: CompaniesScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        label: Text(
          "Create Brand Video",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        icon: Icon(FontAwesomeIcons.video,
            size: 20, color: constantColors.whiteColor),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
              .collection("ambassadorWork")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, userWorkSnap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.height * 0.75,
                width: size.width,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: userWorkSnap.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 256,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot workData = userWorkSnap.data!.docs[index];
                    return Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: constantColors.blueGreyColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: workData['thumbnail'],
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
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: SizedBox(
                            height: 30,
                            child: Lottie.asset("assets/animations/video.json"),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserSubmittedWorkProfile extends StatelessWidget {
  const UserSubmittedWorkProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Brands Works",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
              .collection("submittedWork")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, userWorkSnap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.height * 0.75,
                width: size.width,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: userWorkSnap.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 256,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot workData = userWorkSnap.data!.docs[index];
                    bool approved = workData['approved'] == true ? true : false;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: SeeVideo(documentSnapshot: workData),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: constantColors.blueGreyColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: workData['thumbnail'],
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
                          Visibility(
                            visible: approved,
                            replacement: Positioned(
                              top: 10,
                              right: 5,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: size.width * 0.33,
                                decoration: BoxDecoration(
                                  color: constantColors.redColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.clear,
                                      color: constantColors.whiteColor,
                                    ),
                                    Text(
                                      "Unapproved",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: Positioned(
                              top: 10,
                              right: 5,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: size.width * 0.33,
                                decoration: BoxDecoration(
                                  color: constantColors.greenColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: constantColors.whiteColor,
                                    ),
                                    Text(
                                      "Approved",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: SizedBox(
                              height: 30,
                              child:
                                  Lottie.asset("assets/animations/video.json"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
