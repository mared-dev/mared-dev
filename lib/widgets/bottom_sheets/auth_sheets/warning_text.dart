import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

warningText(BuildContext context, String warning) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.circular(15),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              warning,
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    },
  );
}
