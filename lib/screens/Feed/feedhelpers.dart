import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/helpers/post_helpers.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/AltProfile/altProfileHelper.dart';
import 'package:mared_social/screens/Feed/banners_section.dart';
import 'package:mared_social/screens/Feed/posts_section.dart';
import 'package:mared_social/screens/Feed/stories_section.dart';
import 'package:mared_social/screens/Stories/stories.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:mared_social/services/firebase/firestore/FirebaseOpertaion.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class FeedHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox(
        height: 0,
        width: 0,
      ),
      backgroundColor: constantColors.darkColor.withOpacity(0.8),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
                false) {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            } else {
              IsAnonBottomSheet(context);
            }
          },
          icon: Icon(
            Icons.camera_enhance_rounded,
            color: constantColors.greenColor,
          ),
        ),
      ],
      title: RichText(
        text: TextSpan(
          text: "Mared ",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "Feed",
              style: TextStyle(
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          child: SearchPage(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: constantColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: constantColors.greenColor,
                                width: 1,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.search_outlined,
                                  size: 25,
                                  color: constantColors.darkColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Looking for something?",
                                  style: TextStyle(
                                    color: constantColors.darkColor
                                        .withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BannersSection(),
                    StoriesSection()
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: PostsSection(),
    );
  }

  IsAnonBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: IsAnonMsg(),
          ),
        );
      },
    );
  }
}
