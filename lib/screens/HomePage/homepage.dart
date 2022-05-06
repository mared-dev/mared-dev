import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/controllers/global_messages_controller.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/screens/Categories/category.dart';
import 'package:mared_social/screens/Chatroom/chatroom.dart';
import 'package:mared_social/screens/Feed/admin_posts_feed.dart';
import 'package:mared_social/screens/Feed/feed.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/screens/Profile/profile.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/screens/mapscreen/mapscreen.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/dynamic_link_service.dart';
import 'package:mared_social/utils/popup_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Profile/profileHelpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  int pageIndex = 0;
  bool loading = true;
  bool isAnon = false;

  late PersistentTabController _controller;
  late List<Widget> _screens;
  late List<PersistentBottomNavBarItem> _navBarItems;
  int currentIndex = 0;

  late GlobalMessagesController _globalMessagesController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await load();
      // await Provider.of<FirebaseOperations>(context, listen: false)
      //     .initUserData(context);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
    isAnon = Provider.of<Authentication>(context, listen: false).getIsAnon;

    _controller = PersistentTabController(initialIndex: 0);

    _screens = UserInfoManger.isAdmin()
        ? [
            AdminPostsFeed(
              screenTitle: "Review posts",
              collectionName: 'posts',
            ),
            AdminPostsFeed(
              screenTitle: "Review stories",
              collectionName: 'stories',
            ),
          ]
        : [
            Feed(),
            CategoryScreen(),
            MapScreen(),
          ];

    _navBarItems = UserInfoManger.isAdmin()
        ? [
            _navBarItem(
                itemText: 'posts',
                iconPath: 'assets/icons/post_result_icon.svg',
                index: 0),
            _navBarItem(
                itemText: 'stories',
                iconPath: 'assets/icons/add_story_icon.svg',
                index: 0),
          ]
        : [
            _navBarItem(
                itemText: 'home',
                iconPath: 'assets/icons/navbar_home_icon.svg',
                index: 0),
            _navBarItem(
                itemText: 'menu',
                iconPath: 'assets/icons/navbar_menu_icon.svg',
                index: 1),
            _navBarItem(
                itemText: 'map',
                iconPath: 'assets/icons/navbar_map_icon.svg',
                index: 2),
          ];
    //put it before super for some reason

    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => DynamicLinkService.retrieveDynamicLink(context));

    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);

    _globalMessagesController = Get.find();
    _globalMessagesController.messageToShow.listen((newValue) {
      //find a better way later
      if (newValue.isNotEmpty) {
        PopupUtils.showSuccessPopup(
            title: newValue['title']!,
            body: newValue['body']!,
            context: context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: PersistentTabView(context,
          floatingActionButton: UserInfoManger.getAnonFlag()
              ? null
              : FloatingActionButton(
                  heroTag: "addPostFeed",
                  onPressed: () {
                    ProfileHelpers.postSelectType(context: context);
                  },
                  child:
                      SvgPicture.asset('assets/icons/home_add_post_button.svg'),
                ),
          stateManagement: true,
          margin: EdgeInsets.only(top: 10.h),
          controller: _controller,
          screens: _screens,
          handleAndroidBackButtonPress: true,
          hideNavigationBarWhenKeyboardShows: true,
          items: _navBarItems,
          // padding: NavBarPadding.only(bottom: 10),
          navBarHeight: 65.h,
          padding: NavBarPadding.only(bottom: 12.h),
          backgroundColor: Colors.white,
          navBarStyle: NavBarStyle.style6),
    );
  }

  PersistentBottomNavBarItem _navBarItem(
      {required String itemText,
      required String iconPath,
      required int index}) {
    return PersistentBottomNavBarItem(
      inactiveIcon: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(iconPath,
              width: 22,
              height: 24,
              fit: BoxFit.fill,
              color: AppColors.notActiveNavItemColor),
          SizedBox(
            height: 5.h,
          ),
          Text(
            itemText,
            style: regularTextStyle(
              fontSize: 9,
              textColor: AppColors.notActiveNavItemColor,
            ),
          )
        ],
      ),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(iconPath,
              width: 22,
              height: 24,
              fit: BoxFit.fill,
              color: AppColors.accentColor),
          SizedBox(
            height: 5.h,
          ),
          Text(
            itemText,
            style: regularTextStyle(
              fontSize: 9,
              textColor: AppColors.accentColor,
            ),
          )
        ],
      ),
      // title: "Home",
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
      inactiveColorSecondary: Colors.purple,
    );
  }

  Future<void> load() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );
    } else {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      //     overlays: [SystemUiOverlay.top]);
    }

    _fcm.getAPNSToken().then((value) => print("APN Token === $value"));

    String? token = await _fcm.getToken();
    assert(token != null);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .update({
      'fcmToken': token,
    });
  }
}
