import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/Feed/feedhelpers.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserResultItem extends StatelessWidget {
  final dynamic userData;

  const UserResultItem({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: () {
          if (userData['useruid'] !=
              Provider.of<Authentication>(context, listen: false).getUserId) {
            Navigator.push(
                context,
                PageTransition(
                    child: AltProfile(
                      userUid: userData['useruid'],
                    ),
                    type: PageTransitionType.bottomToTop));
          } else {
            Provider.of<FeedHelpers>(context, listen: false)
                .IsAnonBottomSheet(context);
          }
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: userData['userimage'],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(
              height: 50,
              width: 50,
              child: LoadingWidget(constantColors: constantColors),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          userData['username'],
          style: TextStyle(color: constantColors.whiteColor),
        ),
      ),
    );
  }
}
