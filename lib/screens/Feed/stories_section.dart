import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Stories/stories.dart';
import 'package:page_transition/page_transition.dart';

class StoriesSection extends StatefulWidget {
  @override
  _StoriesSectionState createState() => _StoriesSectionState();
}

class _StoriesSectionState extends State<StoriesSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0, left: 3, bottom: 3, top: 3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Mared Moments",
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("stories")
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, storiesSnaps) {
                if (storiesSnaps.data!.docs.length == 0) {
                  return Center(
                    child: Text(
                      "No Stories Yet",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: storiesSnaps.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: Stories(
                                  querySnapshot: storiesSnaps,
                                  snapIndex: index,
                                ),
                                type: PageTransitionType.bottomToTop),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: constantColors.blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: storiesSnaps.data!.docs[index]
                                          ['userimage'],
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          LoadingWidget(
                                              constantColors: constantColors),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
