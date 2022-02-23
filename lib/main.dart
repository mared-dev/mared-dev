import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/appleSignInCheck.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/Categories/categoryHelpers.dart';
import 'package:mared_social/screens/CategoryFeed/categoryfeedhelper.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:mared_social/screens/Chatroom/privateChatHelpers.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/screens/HomePage/homepageHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingHelpers.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/Messaging/groupmessagehelper.dart';
import 'package:mared_social/screens/Messaging/privateMessageHelper.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/SearchFeed/searchfeedhelper.dart';
import 'package:mared_social/screens/Stories/stories_helper.dart';
import 'package:mared_social/screens/ambassaborsScreens/previewVideoHelper.dart';
import 'package:mared_social/screens/auctionFeed/auctionfeedHelper.dart';
import 'package:mared_social/screens/auctionFeed/placebidhelper.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/auctions/auctionPageHelper.dart';
import 'package:mared_social/screens/isAnon/isAnonHelper.dart';
import 'package:mared_social/screens/mapscreen/category_mapscreenhelper.dart';
import 'package:mared_social/screens/mapscreen/mapscreenhelper.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/screens/searchPage/searchPageHelper.dart';
import 'package:mared_social/screens/splashscreens/splashscreen.dart';
import 'package:mared_social/screens/splitter/splitterhelper.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/utils/auctionoptions.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    importance: Importance.max,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  final appleSignInAvailable = await AppleSignInAvailable.check();

  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        home: WillPopScope(
          onWillPop: () async => false,
          child: SplashScreen(),
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: constantColors.blueColor,
          fontFamily: "Poppins",
          canvasColor: Colors.transparent,
        ),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => PreviewVideoHelper()),
        ChangeNotifierProvider(create: (_) => PromotePostHelper()),
        ChangeNotifierProvider(create: (_) => SearchPageHelper()),
        ChangeNotifierProvider(create: (_) => PlaceBidHelpers()),
        ChangeNotifierProvider(create: (_) => AuctionMapHelper()),
        ChangeNotifierProvider(create: (_) => AuctionFuctions()),
        ChangeNotifierProvider(create: (_) => AuctionFeedHelper()),
        ChangeNotifierProvider(create: (_) => AuctionAppHelper()),
        ChangeNotifierProvider(create: (_) => SplitPagesHelper()),
        ChangeNotifierProvider(create: (_) => IsAnonHelper()),
        ChangeNotifierProvider(create: (_) => CategoryMapScreenHelper()),
        ChangeNotifierProvider(create: (_) => MapScreenHelper()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => HomepageHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
        ChangeNotifierProvider(create: (_) => ChatroomHelpers()),
        ChangeNotifierProvider(create: (_) => GroupMessageHelper()),
        ChangeNotifierProvider(create: (_) => CategoryHelper()),
        ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ChangeNotifierProvider(create: (_) => CatgeoryFeedHelper()),
        ChangeNotifierProvider(create: (_) => SearchFeedHelper()),
        ChangeNotifierProvider(create: (_) => PrivateChatHelpers()),
        ChangeNotifierProvider(create: (_) => PrivateMessageHelper()),
      ],
    );
  }
}
