import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:mared_social/services/fcm_notification_Service.dart';
import 'package:provider/provider.dart';

class FirebaseOperations with ChangeNotifier {
  UploadTask? imageUploadTask;
  late String initUserEmail, initUserName, initUserImage;
  late bool store;
  late String fcmToken;
  int? unReadMsgs;

  int? get getUnReadMsgs => unReadMsgs;
  bool get getStore => store;
  String get getFcmToken => fcmToken;
  String get getInitUserImage => initUserImage;
  String get getInitUserEmail => initUserEmail;
  String get getInitUserName => initUserName;

  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        "userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}");
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask!.whenComplete(
      () {
        print("Image uploaded!");
      },
    );
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          "The user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userAvatarUrl}");
      notifyListeners();
    });
  }

  Future createBannerCollection(
      {required BuildContext context,
      required String bannerId,
      required dynamic data}) async {
    return FirebaseFirestore.instance
        .collection("banners")
        .doc(bannerId)
        .set(data);
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .set(data);
  }

  Future uploadAmbassadorWork(
      {required BuildContext context,
      required DocumentSnapshot vendorData,
      required dynamic inUserDB,
      required String workId}) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .collection("ambassadorWork")
        .doc(workId)
        .set(inUserDB)
        .whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(vendorData.id)
          .collection("submittedWork")
          .doc(workId)
          .set(inUserDB);
    });
  }

  Future approveBrandVideo(
      {required BuildContext context,
      required String userId,
      required String vendorId,
      required String workId}) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("ambassadorWork")
        .doc(workId)
        .update({
      'approved': true,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(vendorId)
          .collection("submittedWork")
          .doc(workId)
          .update({
        'approved': true,
      });
    });
  }

  Future unapproveBrandVideo(
      {required BuildContext context,
      required String userId,
      required String vendorId,
      required String workId}) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("ambassadorWork")
        .doc(workId)
        .update({
      'approved': false,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(vendorId)
          .collection("submittedWork")
          .doc(workId)
          .update({
        'approved': false,
      });
    });
  }

  Future deleteBrandVideo(
      {required BuildContext context,
      required String userId,
      required String vendorId,
      required String workId}) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("ambassadorWork")
        .doc(workId)
        .delete()
        .whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(vendorId)
          .collection("submittedWork")
          .doc(workId)
          .delete();
    });
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((doc) {
      print("fetching user data");
      initUserName = doc['username'];
      initUserEmail = doc['useremail'];
      initUserImage = doc['userimage'];
      store = doc['store'];
      fcmToken = doc['fcmToken'];

      print(fcmToken);
      print(initUserName);
      notifyListeners();
    });
  }

  Future initChatData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .collection("chats")
        .get()
        .then((chats) async {
      chats.docs.forEach((chat) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(Provider.of<Authentication>(context, listen: false).getUserId)
            .collection("chats")
            .doc(chat.id)
            .collection("messages")
            .where("msgSeen", isEqualTo: false)
            .get()
            .then((messages) async {
          print("${messages.docs.length} here");
          unReadMsgs = messages.docs.length;
          notifyListeners();
        });
      });
    });
  }

  Future placeBid(
      {required String bidId,
      required String auctionId,
      required dynamic bidderData,
      required BuildContext context,
      required String currentPrice,
      required dynamic myBidData}) async {
    return FirebaseFirestore.instance
        .collection("auctions")
        .doc(auctionId)
        .collection("bids")
        .doc(bidId)
        .set(bidderData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .collection("myBids")
          .doc(bidId)
          .set(myBidData);
    }).whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("auctions")
          .doc(auctionId)
          .update({
        'currentprice': currentPrice,
      });
    });
  }

  Future uploadAuctionData(String auctionId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("auctions")
        .doc(auctionId)
        .set(data);
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection("posts").doc(postId).set(data);
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future deletePostData(
      {required String postId, required String userUid}) async {
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(userUid)
          .collection("posts")
          .doc(postId)
          .delete()
          .whenComplete(() async {
        return await FirebaseFirestore.instance
            .collection("banners")
            .get()
            .then((bannerCollection) {
          bannerCollection.docs.forEach((element) async {
            if (element['postid'] == postId) {
              await FirebaseFirestore.instance
                  .collection("banners")
                  .doc(element.id)
                  .delete();
            }
          });
        });
      });
    });
  }

  Future notifyOverBid(
      {required String userToken, required String auctionName}) async {
    await _fcmNotificationService.sendNotificationToUser(
        to: userToken, //To change once set up
        title: "Someone else is winning the auction",
        body: "You've been overbid for $auctionName");
  }

  Future deleteAuctionData(
      {required String auctionId, required String userUid}) async {
    return await FirebaseFirestore.instance
        .collection("auctions")
        .doc(auctionId)
        .collection("bids")
        .get()
        .then((bidsCollection) {
      bidsCollection.docs.forEach((bid) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(bid['useruid'])
            .collection("myBids")
            .doc(bid['bidid'])
            .delete();
      });
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("auctions")
          .doc(auctionId)
          .delete()
          .whenComplete(() async {
        return await FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .collection("auctions")
            .doc(auctionId)
            .delete();
      });
    });
  }

  Future deleteUserComment(
      {required String postId, required String commentId}) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete();
  }

  Future deleteAuctionUserComment(
      {required String auctionId, required String commentId}) async {
    return FirebaseFirestore.instance
        .collection("auctions")
        .doc(auctionId)
        .collection("comments")
        .doc(commentId)
        .delete();
  }

  Future addAward({required String postId, required dynamic data}) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("awards")
        .add(data);
  }

  Future updateDescription(
      {required String postId,
      required AsyncSnapshot<DocumentSnapshot> postDoc,
      String? description,
      required BuildContext context}) async {
    String name = "${postDoc.data!['caption']} ${description}";

    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
      }
    }
    return await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .update({
      'description': description,
      'searchindex': indexList,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .collection("posts")
          .doc(postId)
          .update({
        'description': description,
        'searchindex': indexList,
      });
    });
  }

  Future updateAuctionDescription(
      {required String auctionId,
      required AsyncSnapshot<DocumentSnapshot> auctionDoc,
      String? description,
      required BuildContext context}) async {
    String name = "${auctionDoc.data!['title']} ${description}";

    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
      }
    }
    return await FirebaseFirestore.instance
        .collection("auctions")
        .doc(auctionId)
        .update({
      'description': description,
      'searchindex': indexList,
    }).whenComplete(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(Provider.of<Authentication>(context, listen: false).getUserId)
          .collection("auctions")
          .doc(auctionId)
          .update({
        'description': description,
        'searchindex': indexList,
      });
    });
  }

  Future followUser({
    required String followingUid,
    required String followingDocId,
    required dynamic followingData,
    required String followerUid,
    required String followerDocId,
    required dynamic followerData,
  }) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(followingUid)
        .collection("followers")
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(followerUid)
          .collection("following")
          .doc(followerDocId)
          .set(followerData);
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(followingUid)
          .get()
          .then((postUser) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(followerUid)
            .get()
            .then((followingUser) async {
          await _fcmNotificationService.sendNotificationToUser(
              to: postUser['fcmToken']!, //To change once set up
              title: "${followingUser['username']} follows you",
              body: "");
        });
      });
    });
  }

  Future unfollowUser({
    required String followingUid,
    required String followingDocId,
    required String followerUid,
    required String followerDocId,
  }) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(followingUid)
        .collection("followers")
        .doc(followingDocId)
        .delete()
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(followerUid)
          .collection("following")
          .doc(followerDocId)
          .delete();
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(followingUid)
          .get()
          .then((postUser) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(followerUid)
            .get()
            .then((followingUser) async {
          await _fcmNotificationService.sendNotificationToUser(
              to: postUser['fcmToken']!, //To change once set up
              title: "${followingUser['username']} unfollowed you",
              body: "");
        });
      });
    });
  }

  Future submitChatroomData({
    required String chatroomName,
    required dynamic chatroomData,
  }) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomName)
        .set(chatroomData);
  }

  Future messageUser({
    required String messagingUid,
    required String messagingDocId,
    required dynamic messagingData,
    required String messengerUid,
    required String messengerDocId,
    required dynamic messengerData,
  }) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(messagingUid)
        .collection("chats")
        .doc(messagingDocId)
        .set(messagingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(messengerUid)
          .collection("chats")
          .doc(messengerDocId)
          .set(messengerData);
    });
  }

  Future deleteMessage(
      {required String chatroomId, required String messageId}) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  List<String> catNames = [
    'Sports',
    'Services',
    'Events',
    'Homemade',
    'Furniture',
    'Education',
    'Fashion & Beauty',
    'Electronics',
    'Business & Industry',
    'Healthcare',
    'Jobs',
    'Real Estate',
    'Automobiles'
  ];
}
