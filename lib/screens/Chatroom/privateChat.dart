import 'package:flutter/material.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:mared_social/screens/Chatroom/privateChatHelpers.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';

class PrivateChats extends StatelessWidget {
  const PrivateChats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:
          Provider.of<PrivateChatHelpers>(context, listen: false).showChatrooms(
        context: context,
        userUid: Provider.of<Authentication>(context, listen: false).getUserId,
      ),
    );
  }
}
