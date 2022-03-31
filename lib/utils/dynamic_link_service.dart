import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DynamicLinkService {
  static Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        ///
        print('@@@@@@@@@@@@@@@@@@@@@');
        print('app opened in foreground');
        print(deepLink.queryParameters);
        if (deepLink.queryParameters.containsKey('post_id')) {
          String id = deepLink.queryParameters['post_id']!;
          print('!!!!!!!!!!!!!!!!!!!!');
          print(id);

          pushNewScreen(
            context,
            screen: PostDetailsScreen(postId: id),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      }

      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        print('@@@@@@@@@@@@@@@@@@@@@');
        print('app opened in background');
        print(dynamicLinkData.link.queryParameters);
        if (dynamicLinkData.link.queryParameters.containsKey('post_id')) {
          String id = dynamicLinkData.link.queryParameters['post_id']!;
          print('!!!!!!!!!!!!!!!!!!!!');
          print(id);

          pushNewScreen(
            context,
            screen: PostDetailsScreen(postId: id),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        }
      }).onError((error) {
        // Handle errors
      });
    } catch (e) {
      print(e.toString());
    }
  }

  ///createDynamicLink()
  static Future<Uri> createDynamicLink(String id, {bool short = false}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://mared.page.link',
      link: Uri.parse('https://mared.maredapp.com/?post_id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'ke.co.rufw91.mared',
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.anket.mared',
        minimumVersion: '1',
        appStoreId: '1547218031',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    print('%%%%%%%%%%%%%%%%%%');
    print(url.toString());
    print(url.path);
    print(url.data);

    return url;
  }
}
