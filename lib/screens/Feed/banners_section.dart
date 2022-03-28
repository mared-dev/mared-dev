import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/text_styles.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/AltProfile/altProfile.dart';
import 'package:mared_social/screens/PostDetails/post_details_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class BannersSection extends StatefulWidget {
  @override
  _BannersSectionState createState() => _BannersSectionState();
}

class _BannersSectionState extends State<BannersSection> {
  var currentPage = 0.obs;
  String selectedUserId = "";
  String selectedPostId = "";
  late UserModel selectedUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("banners")
          .where("enddate", isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .get(),
      builder: (context, bannerSnap) {
        if (bannerSnap.connectionState == ConnectionState.waiting ||
            !bannerSnap.hasData ||
            bannerSnap.data == null) {
          return LoadingWidget(constantColors: constantColors);
        } else {
          if (selectedUserId.isEmpty) {
            var bannerItem = bannerSnap.data!.docs[0];
            selectedUserId = bannerItem['useruid'];
            selectedPostId = bannerItem['postid'];
            selectedUser = UserModel(
                userName: bannerItem['username'],
                email: bannerItem['useremail'],
                photoUrl: bannerItem['userimage'],
                fcmToken: '',
                store: false,
                uid: bannerItem['useruid']);
          }

          return Container(
            margin: EdgeInsets.only(top: 8.h, bottom: 18.h),
            alignment: Alignment.center,
            height: 254.h,
            width: 1.sw,
            child: Stack(
              children: [
                Swiper(
                  onIndexChanged: (newIndex) {
                    var bannerItem = bannerSnap.data!.docs[newIndex];
                    print('##################');
                    print(newIndex);
                    print(bannerItem['username']);
                    print(bannerItem['useremail']);
                    selectedUser = UserModel(
                        userName: bannerItem['username'],
                        email: bannerItem['useremail'],
                        photoUrl: bannerItem['userimage'],
                        fcmToken: '',
                        store: false,
                        uid: bannerItem['useruid']);
                    selectedUserId = bannerItem['useruid'];
                    selectedPostId = bannerItem['postid'];

                    currentPage.value = newIndex;
                  },
                  itemCount: bannerSnap.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 18.h),
                        color: Colors.grey,
                        height: 204.h,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: bannerSnap.data!.docs[index]['imageslist']
                                [0],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              return LoadingWidget(
                                  constantColors: constantColors);
                            },
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                  layout: SwiperLayout.DEFAULT,
                  autoplay: false,
                  duration: 1000,
                  curve: Curves.fastOutSlowIn,
                ),
                Obx(() => SwiperIndicator(
                      selectedPostId: selectedPostId,
                      selectedUserId: selectedUserId,
                      initialPage: currentPage.value,
                      numOfDots: bannerSnap.data!.docs.length,
                      userModel: selectedUser,
                    ))
              ],
            ),
          );
        }
      },
    );
  }
}

class SwiperIndicator extends StatelessWidget {
  final int initialPage;
  final int numOfDots;
  final String selectedUserId;
  final String selectedPostId;
  final UserModel userModel;

  const SwiperIndicator(
      {Key? key,
      required this.userModel,
      required this.initialPage,
      required this.numOfDots,
      required this.selectedPostId,
      required this.selectedUserId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12.h,
      left: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        width: 1.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen: PostDetailsScreen(
                    userId: selectedUserId,
                    postId: selectedPostId,
                  ),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(
                'View post',
                style: semiBoldTextStyle(
                  fontSize: 11,
                  textColor: Colors.black,
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: PageController(initialPage: initialPage),
              onDotClicked: (index) {
                print('index');
              },
              // count: bannerSnap.data!.docs.length,
              count: numOfDots,
              axisDirection: Axis.horizontal,
              effect: ScrollingDotsEffect(
                  spacing: 8.0,
                  radius: 20.0,
                  dotWidth: 6,
                  dotHeight: 6,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 1.5,
                  dotColor: Colors.black.withOpacity(0.1),
                  activeDotColor: Colors.black.withOpacity(0.7)),
            ),
            InkWell(
              onTap: () {
                pushNewScreen(
                  context,
                  screen:
                      AltProfile(userUid: selectedUserId, userModel: userModel),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Text(
                'View profile',
                style: semiBoldTextStyle(
                  fontSize: 11,
                  textColor: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
