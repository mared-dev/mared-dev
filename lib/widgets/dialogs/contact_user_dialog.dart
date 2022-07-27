import 'package:flutter/material.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/utils/url_launcher_utils.dart';

Future showContactDialog({required String phoneNumber, required context}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _contactItem(
                displayText: 'Contact user',
                iconData: Icons.call,
                paddingValues: EdgeInsets.only(top: 4, bottom: 8),
                callback: () {
                  UrlLauncherUtils.dialNumber(phoneNumber);
                }),
            Divider(),
            _contactItem(
                paddingValues: EdgeInsets.only(top: 8, bottom: 4),
                displayText: 'Send a whatsapp message',
                iconData: Icons.whatsapp,
                callback: () {
                  UrlLauncherUtils.openWhatsapp(phoneNumber);
                })
          ],
        ));
      });
}

Widget _contactItem(
    {required String displayText,
    required IconData iconData,
    required void Function() callback,
    required EdgeInsetsGeometry paddingValues}) {
  return InkWell(
    onTap: callback,
    child: Padding(
      padding: paddingValues,
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              displayText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: regularTextStyle(
                  fontSize: 14, textColor: AppColors.commentButtonColor),
            ),
          ),
        ],
      ),
    ),
  );
}
