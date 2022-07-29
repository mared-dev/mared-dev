import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/helpers/loading_helper.dart';
import 'package:mared_social/utils/dynamic_link_service.dart';
import 'package:mared_social/widgets/bottom_sheets/show_comments_section.dart';
import 'package:share_plus/share_plus.dart';

class PostSharePart extends StatelessWidget {
  final String postId;

  const PostSharePart({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        LoadingHelper.startLoading();
        var generatedLink =
            await DynamicLinkService.createDynamicLink(postId, short: true);
        Share.share('check out this product ' + generatedLink.toString());
        LoadingHelper.endLoading();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 8.w, top: 10.h, bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25.w,
            ),
            SvgPicture.asset('assets/icons/post_share_icon.svg'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('share'.tr(),
                  style: regularTextStyle(
                      fontSize: 11.sp,
                      textColor: AppColors.commentButtonColor)),
            ),
          ],
        ),
      ),
    );
  }
}
