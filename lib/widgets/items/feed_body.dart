import 'package:flutter/material.dart';
import 'package:mared_social/screens/Feed/banners_section.dart';
import 'package:mared_social/screens/Feed/posts_section.dart';
import 'package:mared_social/screens/Feed/stories_section.dart';
import 'package:mared_social/screens/searchPage/searchPage.dart';
import 'package:page_transition/page_transition.dart';

import '../bottom_sheets.dart';

class FeedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///START HERE
    ///there is something wrong with the rebuilds
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: constantColors.blueGreyColor,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          child: SearchPage(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: constantColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: constantColors.greenColor,
                                width: 1,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.search_outlined,
                                  size: 25,
                                  color: constantColors.darkColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Looking for something?",
                                  style: TextStyle(
                                    color: constantColors.darkColor
                                        .withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BannersSection(),
                    StoriesSection()
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: PostsSection(),
    );
  }
}
