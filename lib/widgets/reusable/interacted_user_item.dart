import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

class InteractedUserItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Widget? trailingIcon;
  final Function() leadingCallback;
  final Function()? trailingCallback;

  const InteractedUserItem(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.subtitle,
      required this.leadingCallback,
      this.trailingIcon,
      this.trailingCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () {
          print('222222222222222');

          // if (likesItem['useruid'] !=
          //     Provider.of<Authentication>(context,
          //         listen: false)
          //         .getUserId) {
          //   Navigator.pushReplacement(
          //       context,
          //       PageTransition(
          //           child: AltProfile(
          //             userUid: likesItem['useruid'],
          //           ),
          //           type:
          //           PageTransitionType.bottomToTop));
          // }
        },
        child: Container(
          width: 60,
          height: 60,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          print('222222222222222');

          // if (likesItem['useruid'] !=
          //     Provider.of<Authentication>(context,
          //         listen: false)
          //         .getUserId) {
          //   Navigator.pushReplacement(
          //       context,
          //       PageTransition(
          //           child: AltProfile(
          //             userUid: likesItem['useruid'],
          //           ),
          //           type:
          //           PageTransitionType.bottomToTop));
          // }
        },
        child: Text(
          title,
          style:
              semiBoldTextStyle(fontSize: 15, textColor: AppColors.accentColor),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: regularTextStyle(
            fontSize: 11, textColor: AppColors.commentButtonColor),
      ),

      ///TODO :fix this later (the follow/ unfollow flow in the screen)
      trailing: InkWell(
          onTap: () {
            print('99999999999999');
          },
          child: trailingIcon),
    );
  }
}
