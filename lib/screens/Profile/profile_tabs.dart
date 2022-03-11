// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/models/user_model.dart';
import 'package:mared_social/screens/Profile/profileHelpers.dart';
import 'package:mared_social/screens/ambassaborsScreens/companiesScreen.dart';
import 'package:mared_social/screens/ambassaborsScreens/seeVideo.dart';
import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
import 'package:mared_social/screens/userSettings/usersettings.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/widgets/items/profile_post_item.dart';
import 'package:mared_social/widgets/items/promoted_post_item.dart';
import 'package:mared_social/widgets/items/show_post_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostsProfile extends StatelessWidget {
  const PostsProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    UserModel _userInfo = UserInfoManger.getUserInfo();
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: UserSettingsPage(),
                    type: PageTransitionType.leftToRight));
          },
          icon: Icon(
            FontAwesomeIcons.cogs,
            color: constantColors.greenColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "My ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Profile",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.darkColor,
        onPressed: () {
          Provider.of<ProfileHelpers>(context, listen: false)
              .postSelectType(context: context);
        },
        child: Stack(
          children: [
            Center(
              child: Icon(
                EvaIcons.plusCircleOutline,
                color: constantColors.whiteColor,
              ),
            ),
            Lottie.asset("assets/animations/cool.json"),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.43,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  color: constantColors.blueGreyColor,
                  child: Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .headerProfile(context, _userInfo),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .middleProfile(context, _userInfo),
                    ],
                  )),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserId)
                .collection("posts")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, userPostSnap) {
              return SliverPadding(
                padding: const EdgeInsets.all(4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.toInt() < userPostSnap.data!.docs.length) {
                        var userPostDocSnap = userPostSnap.data!.docs[index];
                        // print('############');
                        // print(userPostSnap.data!.docs.toString());
                        // print(userPostDocSnap['imageslist']);
                        return InkWell(
                            onTap: () {
                              showPostDetail(
                                  context: context,
                                  documentSnapshot: userPostDocSnap);
                            },
                            child: ProfilePostItem(
                              urls: userPostDocSnap['imageslist'],
                            ));
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class AuctionsProfile extends StatelessWidget {
//   const AuctionsProfile({
//     Key? key,
//     required this.constantColors,
//     required this.size,
//   }) : super(key: key);
//
//   final ConstantColors constantColors;
//   final Size size;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: constantColors.blueGreyColor,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Provider.of<ProfileHelpers>(context, listen: false)
//                   .logOutDialog(context);
//             },
//             icon: Icon(
//               EvaIcons.logOutOutline,
//               color: constantColors.greenColor,
//             ),
//           ),
//         ],
//         backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
//         title: RichText(
//           text: TextSpan(
//             text: "My ",
//             style: TextStyle(
//               color: constantColors.whiteColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//             children: <TextSpan>[
//               TextSpan(
//                 text: "Auctions",
//                 style: TextStyle(
//                   color: constantColors.blueColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: constantColors.darkColor,
//         onPressed: () {
//           Navigator.push(
//               context,
//               PageTransition(
//                   child: CreateAuctionScreen(),
//                   type: PageTransitionType.rightToLeft));
//         },
//         label: Text(
//           "Post Auction",
//           style: TextStyle(
//             color: constantColors.whiteColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//         ),
//         icon: Lottie.asset(
//           "assets/animations/gavel.json",
//           height: 20,
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             expandedHeight: size.height * 0.43,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 color: constantColors.blueGreyColor,
//                 child: StreamBuilder<DocumentSnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("users")
//                       .doc(Provider.of<Authentication>(context, listen: false)
//                           .getUserId)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else {
//                       return Column(
//                         children: [
//                           Provider.of<ProfileHelpers>(context, listen: false)
//                               .headerProfile(context, snapshot),
//                           Provider.of<ProfileHelpers>(context, listen: false)
//                               .divider(),
//                           Provider.of<ProfileHelpers>(context, listen: false)
//                               .middleProfile(context, snapshot),
//                         ],
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection("users")
//                 .doc(Provider.of<Authentication>(context, listen: false)
//                     .getUserId)
//                 .collection("auctions")
//                 .orderBy("time", descending: true)
//                 .snapshots(),
//             builder: (context, userAuctionSnap) {
//               return SliverPadding(
//                 padding: const EdgeInsets.all(4),
//                 sliver: SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 5,
//                     mainAxisSpacing: 5,
//                   ),
//                   delegate: SliverChildBuilderDelegate(
//                     (BuildContext context, int index) {
//                       if (index.toInt() < userAuctionSnap.data!.docs.length) {
//                         var userAuctionDocSnap =
//                             userAuctionSnap.data!.docs[index];
//
//                         bool dateCheck = DateTime.now().isBefore(
//                             (userAuctionDocSnap['enddate'] as Timestamp)
//                                 .toDate());
//                         return InkWell(
//                           onTap: () {
//                             Provider.of<AuctionMapHelper>(context,
//                                     listen: false)
//                                 .showAuctionDetails(
//                                     context: context,
//                                     documentSnapshot: userAuctionDocSnap);
//                           },
//                           child: Stack(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(2.0),
//                                 child: SizedBox(
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(5),
//                                     child: Swiper(
//                                       itemBuilder:
//                                           (BuildContext context, int index) {
//                                         return CachedNetworkImage(
//                                           fit: BoxFit.cover,
//                                           imageUrl:
//                                               userAuctionDocSnap['imageslist']
//                                                   [index],
//                                           progressIndicatorBuilder: (context,
//                                                   url, downloadProgress) =>
//                                               SizedBox(
//                                             height: 50,
//                                             width: 50,
//                                             child: LoadingWidget(
//                                                 constantColors: constantColors),
//                                           ),
//                                           errorWidget: (context, url, error) =>
//                                               const Icon(Icons.error),
//                                         );
//                                       },
//                                       itemCount:
//                                           (userAuctionDocSnap['imageslist']
//                                                   as List)
//                                               .length,
//                                       itemHeight:
//                                           MediaQuery.of(context).size.height *
//                                               0.3,
//                                       itemWidth:
//                                           MediaQuery.of(context).size.width,
//                                       layout: SwiperLayout.DEFAULT,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: dateCheck,
//                                 replacement: Container(
//                                   height: size.height,
//                                   width: size.width,
//                                   decoration: BoxDecoration(
//                                     color: constantColors.greyColor
//                                         .withOpacity(0.9),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Auction Over",
//                                       style: TextStyle(
//                                         color: constantColors.whiteColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 child: Positioned(
//                                   top: 5,
//                                   right: 5,
//                                   child: SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: Lottie.asset(
//                                       "assets/animations/gavel.json",
//                                       height: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class AmbassadorProfile extends StatelessWidget {
  const AmbassadorProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Ambassador",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: CompaniesScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        label: Text(
          "Create Brand Video",
          style: TextStyle(
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        icon: Icon(FontAwesomeIcons.video,
            size: 20, color: constantColors.whiteColor),
      ),
      body: SingleChildScrollView(
        ///no need for realtime data for now
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
              .collection("ambassadorWork")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, userWorkSnap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.height * 0.75,
                width: size.width,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: userWorkSnap.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 256,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot workData = userWorkSnap.data!.docs[index];
                    return Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: constantColors.blueGreyColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: workData['thumbnail'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingWidget(
                                    constantColors: constantColors),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: SizedBox(
                            height: 30,
                            child: Lottie.asset("assets/animations/video.json"),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserSubmittedWorkProfile extends StatelessWidget {
  const UserSubmittedWorkProfile({
    Key? key,
    required this.constantColors,
    required this.size,
  }) : super(key: key);

  final ConstantColors constantColors;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .logOutDialog(context);
            },
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
          ),
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Brands Works",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),

      ///no need for this to be fetched in realtime
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
              .collection("submittedWork")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, userWorkSnap) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: size.height * 0.75,
                width: size.width,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: userWorkSnap.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 256,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot workData = userWorkSnap.data!.docs[index];
                    bool approved = workData['approved'] == true ? true : false;
                    return PromotedPostItem(
                      isApproved: approved,
                      workData: workData,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
