import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:provider/provider.dart';

class PostLikesPart extends StatelessWidget {
  final postId;
  final likes;

  const PostLikesPart({Key? key, required this.postId, required this.likes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<PostFunctions>(context, listen: false)
            .showLikes(context: context, likes: likes);
      },
      child: SizedBox(
        width: 60,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                likes.any((element) =>
                        element['useruid'] ==
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId)
                    ? EvaIcons.heart
                    : EvaIcons.heartOutline,
                color: constantColors.redColor,
                size: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  likes.length.toString(),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
