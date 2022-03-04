import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Stories/stories.dart';
import 'package:page_transition/page_transition.dart';

class FeedStoryItem extends StatelessWidget {
  final int index;
  final storiesSnaps;

  const FeedStoryItem(
      {Key? key, required this.index, required this.storiesSnaps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
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
                    imageUrl: storiesSnaps.data!.docs[index]['userimage'],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            LoadingWidget(constantColors: constantColors),
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
  }
}
