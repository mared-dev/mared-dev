import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';

class EmptySearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: AppColors.backGroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: 400,
            child: Lottie.asset(
              "assets/animations/empty.json",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Center(
              child: Text(
                  "No results found, please use the above search bar to find your desired item",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: regularTextStyle(
                      fontSize: 13, textColor: AppColors.commentButtonColor)),
            ),
          )
        ],
      ),
    );
  }
}
