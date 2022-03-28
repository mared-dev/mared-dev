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
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Stories/stories_widget.dart';
import 'package:mared_social/screens/ambassaborsScreens/companiesScreen.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final StoryWidgets storyWidgets = StoryWidgets();

  Widget headerProfile(BuildContext context, UserModel userModel) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.255,
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
                              imageUrl: userModel.photoUrl,
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
                      userModel.userName,
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
                              userModel.email,
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
                    visible: UserInfoManger.getUserInfo().store,
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
                              context: context, userId: userModel.uid);
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
                                      .doc(userModel.uid)
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
                              context: context, userId: userModel.uid);
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
                                      .doc(userModel.uid)
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
                            .doc(userModel.uid)
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
        // CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.gavel)),
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

        ///this is for the auction section
        // CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.gavel)),
        CustomNavigationBarItem(icon: const Icon(FontAwesomeIcons.streetView)),
        CustomNavigationBarItem(
            icon: const Icon(FontAwesomeIcons.networkWired)),
      ],
    );
  }

  Widget middleProfile(BuildContext context, UserModel userModel) {
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
                      UserInfoManger.getUserInfo().store == false
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
            child: UserInfoManger.getUserInfo().store == false
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(userModel.uid)
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
                        .doc(userModel.uid)
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
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LandingPage()),
            (Route<dynamic> route) => false,
          );
          // pushNewScreen(
          //   context,
          //   screen: LandingPage(),
          //   withNavBar: false, // OPTIONAL VALUE. True by default.
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   PageTransition(
          //     child: LandingPage(),
          //     type: PageTransitionType.topToBottom,
          //   ),
          //   (Route<dynamic> route) => false,
          // );
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
                            .selectPostType(context);
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
      {required BuildContext context, required dynamic userId}) {
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
                    .doc(userId)
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
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     PageTransition(
                                  //         child: AltProfile(
                                  //           userUid:
                                  //               followingDocSnap['useruid'],
                                  //         ),
                                  //         type:
                                  //             PageTransitionType.bottomToTop));
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
                      "${userId.toString()} is not following anyone",
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

  checkFollowerSheet({required BuildContext context, required dynamic userId}) {
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
                    .doc(userId)
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
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     PageTransition(
                                  //         child: AltProfile(
                                  //           userUid: followerDocSnap['useruid'],
                                  //         ),
                                  //         type:
                                  //             PageTransitionType.bottomToTop));
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
                      "${userId.toString()} is not following anyone",
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
}
