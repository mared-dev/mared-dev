import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/uploadpost.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:provider/provider.dart';

PreferredSizeWidget homeAppBar(BuildContext context) {
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
