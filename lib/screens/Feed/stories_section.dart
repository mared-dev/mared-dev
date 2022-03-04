import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/widgets/items/feed_story_item.dart';

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
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("stories")
                  .orderBy('time', descending: true)
                  .get(),
              builder: (context, storiesSnaps) {
                if (storiesSnaps.hasData &&
                    storiesSnaps.data!.docs.length == 0) {
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
                } else if (storiesSnaps.connectionState ==
                        ConnectionState.done &&
                    storiesSnaps.hasData &&
                    storiesSnaps.data != null) {
                  return ListView.builder(
                    itemCount: storiesSnaps.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return FeedStoryItem(
                        index: index,
                        storiesSnaps: storiesSnaps,
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
