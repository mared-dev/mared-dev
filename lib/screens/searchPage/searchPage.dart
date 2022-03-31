import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/colors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/screens/searchPage/search_page_header_tabs.dart';
import 'package:mared_social/screens/searchPage/searchPageWidgets.dart';
import 'package:mared_social/widgets/reusable/simple_appbar_with_back.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ConstantColors constantColors = ConstantColors();
  final textController = TextEditingController();
  final PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backGroundColor,
      appBar: simpleAppBarWithBack(context,
          title: 'Search',
          leadingIcon: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            fit: BoxFit.fill,
            width: 22.w,
            height: 22.h,
          ), leadingCallback: () {
        Navigator.of(context).pop();
      }),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 18.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: textController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                style: regularTextStyle(
                    fontSize: 12, textColor: AppColors.commentButtonColor),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
                  filled: true,
                  fillColor: AppColors.backGroundColor,
                  hintText: "Search here...",
                  hintStyle: regularTextStyle(
                      fontSize: 12, textColor: AppColors.commentButtonColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: AppColors.commentButtonColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      textController.clear();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.commentButtonColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 28.h,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width,
                    child: SearchPageHeaderTabs(
                      pageController: pageController,
                    )),
              ),
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: PageView(
                    controller: pageController,
                    children: [
                      UserSearchResultBody(
                        isVendor: false,
                        searchQuery: textController.text,
                        searchIndexName: 'usersearchindex',
                        collectionName: 'users',
                      ),
                      UserSearchResultBody(
                        isVendor: true,
                        searchQuery: textController.text,
                        searchIndexName: 'usersearchindex',
                        collectionName: 'users',
                      ),
                      PostSearch(
                        postSearchVal: textController.text,
                      ),
                      // AuctionSearch(
                      //   auctionSearchVal: textController.text,
                      // ),
                    ],
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() {
                        pageIndex = page;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
