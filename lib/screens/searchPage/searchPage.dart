import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/searchPage/searchPageHelper.dart';
import 'package:mared_social/screens/searchPage/searchPageWidgets.dart';
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
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text(
          "Search Page",
          style: TextStyle(
            color: constantColors.whiteColor,
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: textController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                style: TextStyle(
                  color: constantColors.whiteColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: constantColors.darkColor,
                  hintText: "What do you desire?",
                  hintStyle: TextStyle(
                    color: constantColors.lightColor.withOpacity(0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: constantColors.whiteColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      textController.clear();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.clear,
                      color: constantColors.whiteColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width,
                    child: Provider.of<SearchPageHelper>(context, listen: false)
                        .topNavBar(context, pageIndex, pageController)),
              ),
              SizedBox(
                height: size.height * 0.7,
                width: size.width,
                child: PageView(
                  controller: pageController,
                  children: [
                    UserSearch(
                      userSearchVal: textController.text,
                    ),
                    VendorSearch(
                      vendorSearchVal: textController.text,
                    ),
                    PostSearch(
                      postSearchVal: textController.text,
                    ),
                    AuctionSearch(
                      auctionSearchVal: textController.text,
                    ),
                  ],
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      pageIndex = page;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
