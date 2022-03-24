import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/widgets/reusable/interacted_user_item.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LikesScreen extends StatelessWidget {
  final likes;

  const LikesScreen({Key? key, this.likes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Likes',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          children: likes
              .map<Widget>((likeItem) => InteractedUserItem(
                  imageUrl: likeItem['userimage'],
                  title: likeItem['username'],
                  subtitle: likeItem['useremail'],
                  trailingIcon:
                      SvgPicture.asset('assets/icons/follow_icon.svg'),
                  leadingCallback: () {
                    if (likeItem['useruid'] !=
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId) {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AltProfile(
                                userUid: likeItem['useruid'],
                              ),
                              type: PageTransitionType.bottomToTop));
                    }
                  }))
              .toList()),
    );
  }
}
