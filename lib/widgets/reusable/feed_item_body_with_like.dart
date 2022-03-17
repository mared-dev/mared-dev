import 'package:flutter/material.dart';
import 'package:mared_social/mangers/user_info_manger.dart';
import 'package:mared_social/services/firebase/authentication.dart';
import 'package:mared_social/utils/postoptions.dart';
import 'package:mared_social/widgets/bottom_sheets/is_anon_bottom_sheet.dart';
import 'package:mared_social/widgets/reusable/feed_post_item.dart';
import 'package:mared_social/widgets/reusable/feed_post_item_body.dart';
import 'package:provider/provider.dart';

class FeedItemBodyWithLike extends StatefulWidget {
  final imageList;
  final userId;
  final postId;
  final likes;

  const FeedItemBodyWithLike({
    Key? key,
    this.imageList,
    this.userId,
    this.postId,
    this.likes,
  }) : super(key: key);
  @override
  _FeedItemWithLikeState createState() => _FeedItemWithLikeState();
}

class _FeedItemWithLikeState extends State<FeedItemBodyWithLike> {
  bool isAnimating = false;
  bool isAlreadyLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAnimating = false;
    isAlreadyLiked = widget.likes
        .any((element) => element['useruid'] == UserInfoManger.getUserId());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (Provider.of<Authentication>(context, listen: false).getIsAnon ==
            false) {
          if (!isAlreadyLiked) {
            setState(() {
              isAnimating = true;
              isAlreadyLiked = true;
            });
          } else {
            setState(() {
              isAlreadyLiked = false;
            });
          }

          Provider.of<PostFunctions>(context, listen: false).addLike(
            userUid: widget.userId,
            context: context,
            postID: widget.postId,
            subDocId:
                Provider.of<Authentication>(context, listen: false).getUserId,
          );
        } else {
          IsAnonBottomSheet(context);
        }
      },
      child: Stack(
        children: [
          FeedPostItemBody(
            imageList: widget.imageList,
            userId: widget.userId,
            postId: widget.postId,
          ),
          HeartIconAnimated(
              isAnimating: isAnimating,
              animationFinishedCallback: () {
                setState(() {
                  isAnimating = false;
                });
              }),
        ],
      ),
    );
  }
}

class HeartIconAnimated extends StatefulWidget {
  final bool isAnimating;
  final Function animationFinishedCallback;

  const HeartIconAnimated(
      {Key? key,
      required this.isAnimating,
      required this.animationFinishedCallback})
      : super(key: key);
  @override
  _HeartIconAnimatedState createState() => _HeartIconAnimatedState();
}

class _HeartIconAnimatedState extends State<HeartIconAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _scale;
  bool animationFinished = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
  }

  //this when the init state don't work and you need something to init the app
  @override
  void didUpdateWidget(covariant HeartIconAnimated oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && oldWidget.isAnimating != widget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    print('hhhhhhhhhhh');
    animationFinished = false;
    await animationController.forward();
    await animationController.reverse();
    setState(() {
      animationFinished = true;
      widget.animationFinishedCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !animationFinished && widget.isAnimating,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.44,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
}