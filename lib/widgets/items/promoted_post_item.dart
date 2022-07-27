// import 'package:flutter/material.dart';
// // ignore: file_names
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:card_swiper/card_swiper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mared_social/constants/Constantcolors.dart';
// import 'package:mared_social/helpers/stateful_wrapper.dart';
// import 'package:mared_social/screens/Profile/profileHelpers.dart';
// import 'package:mared_social/screens/auctionFeed/createAuctionScreen.dart';
// import 'package:mared_social/screens/auctionMap/auctionMapHelper.dart';
// import 'package:mared_social/screens/userSettings/usersettings.dart';
// import 'package:mared_social/services/firebase/authentication.dart';
// import 'package:mared_social/widgets/items/profile_post_item.dart';
// import 'package:mared_social/widgets/items/show_post_details.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
//
// class PromotedPostItem extends StatelessWidget {
//   final workData;
//   final bool isApproved;
//
//   PromotedPostItem({Key? key, required this.workData, required this.isApproved})
//       : super(key: key);
//
//   late Size size;
//
//   @override
//   Widget build(BuildContext context) {
//     return StatefulWrapper(
//       onInit: () {
//         size = MediaQuery.of(context).size;
//       },
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//               context,
//               PageTransition(
//                   child: SeeVideo(documentSnapshot: workData),
//                   type: PageTransitionType.rightToLeft));
//         },
//         child: Stack(
//           children: [
//             Container(
//               height: double.infinity,
//               width: double.infinity,
//               color: constantColors.blueGreyColor,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: workData['thumbnail'],
//                   progressIndicatorBuilder: (context, url, downloadProgress) =>
//                       SizedBox(
//                     height: 50,
//                     width: 50,
//                     child: LoadingWidget(constantColors: constantColors),
//                   ),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: isApproved,
//               replacement: Positioned(
//                 top: 10,
//                 right: 5,
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: 30,
//                   width: size.width * 0.33,
//                   decoration: BoxDecoration(
//                     color: constantColors.redColor,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.clear,
//                         color: constantColors.whiteColor,
//                       ),
//                       Text(
//                         "Unapproved",
//                         style: TextStyle(
//                           color: constantColors.whiteColor,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               child: Positioned(
//                 top: 10,
//                 right: 5,
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: 30,
//                   width: size.width * 0.33,
//                   decoration: BoxDecoration(
//                     color: constantColors.greenColor,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.check,
//                         color: constantColors.whiteColor,
//                       ),
//                       Text(
//                         "Approved",
//                         style: TextStyle(
//                           color: constantColors.whiteColor,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 5,
//               right: 5,
//               child: SizedBox(
//                 height: 30,
//                 child: Lottie.asset("assets/animations/video.json"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
