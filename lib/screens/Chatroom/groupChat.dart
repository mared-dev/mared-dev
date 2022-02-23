import 'package:flutter/material.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:provider/provider.dart';

class GroupChats extends StatelessWidget {
  const GroupChats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Provider.of<ChatroomHelpers>(context, listen: false)
          .showChatrooms(context: context),
    );
  }
}
