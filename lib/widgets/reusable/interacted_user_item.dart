import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/mangers/user_info_manger.dart';

class InteractedUserItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String itemUserId;
  final String subtitle;
  final bool shouldShowIcon;
  final Widget? trailingIcon;
  final Function() leadingCallback;
  final Function()? trailingCallback;

  const InteractedUserItem(
      {Key? key,
      required this.imageUrl,
      required this.itemUserId,
      required this.title,
      required this.subtitle,
      required this.shouldShowIcon,
      required this.leadingCallback,
      this.trailingIcon,
      this.trailingCallback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(itemUserId);
    print(UserInfoManger.getUserId());
    return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: GestureDetector(
          onTap: () {
            if (leadingCallback != null) {
              leadingCallback();
            }
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
            if (leadingCallback != null) {
              leadingCallback();
            }
          },
          child: Text(
            title,
            style: semiBoldTextStyle(
                fontSize: 15, textColor: AppColors.accentColor),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: regularTextStyle(
              fontSize: 11, textColor: AppColors.commentButtonColor),
        ),
        trailing: (trailingIcon != null && shouldShowIcon)
            ? InkWell(
                onTap: () {
                  if (trailingCallback != null) {
                    trailingCallback!();
                  }
                },
                child: trailingIcon)
            : null);
  }
}
