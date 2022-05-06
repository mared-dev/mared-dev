import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/appleSignInCheck.dart';
import 'package:mared_social/screens/Categories/categoryHelpers.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:mared_social/screens/Chatroom/privateChatHelpers.dart';
import 'package:mared_social/screens/Messaging/groupmessagehelper.dart';
import 'package:mared_social/screens/Messaging/privateMessageHelper.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:mared_social/screens/Stories/stories_helper.dart';
import 'package:mared_social/screens/auctionFeed/auctionfeedHelper.dart';
import 'package:mared_social/screens/auctionFeed/placebidhelper.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/auctions/auctionPageHelper.dart';
import 'package:mared_social/screens/isAnon/isAnonHelper.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/screens/splashscreens/splashscreen.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:provider/provider.dart';

import 'config.dart';

void main() async {
  await config();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MultiProvider(
        child: MaterialApp(
          builder: EasyLoading.init(),
          home: WillPopScope(
            onWillPop: () async => false,
            child: SplashScreen(),
            // child: LandingPage(),
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            accentColor: constantColors.blueColor,
            fontFamily: "Poppins",
            canvasColor: Colors.transparent,
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => PromotePostHelper()),
          ChangeNotifierProvider(create: (_) => PlaceBidHelpers()),
          ChangeNotifierProvider(create: (_) => AuctionMapHelper()),
          ChangeNotifierProvider(create: (_) => AuctionFuctions()),
          ChangeNotifierProvider(create: (_) => AuctionFeedHelper()),
          ChangeNotifierProvider(create: (_) => AuctionAppHelper()),
          ChangeNotifierProvider(create: (_) => IsAnonHelper()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ChatroomHelpers()),
          ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
          ChangeNotifierProvider(create: (_) => CategoryHelper()),
          ChangeNotifierProvider(create: (_) => StoriesHelper()),
          ChangeNotifierProvider(create: (_) => SearchFeedHelper()),
          ChangeNotifierProvider(create: (_) => PrivateChatHelpers()),
          ChangeNotifierProvider(create: (_) => PrivateMessageHelper()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
        ],
      ),
    );
  }
}
