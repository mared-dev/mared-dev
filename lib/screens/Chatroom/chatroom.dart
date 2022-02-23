import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/Chatroom/chatroom_helpers.dart';
import 'package:mared_social/screens/Chatroom/groupChat.dart';
import 'package:mared_social/screens/Chatroom/privateChat.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatefulWidget {
  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final PageController chatTypeController = PageController();

  int pageIndex = 0;

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Provider.of<ChatroomHelpers>(context, listen: false).bottomNavBar(
        context: context,
        index: pageIndex,
        pageController: chatTypeController,
      ),
      floatingActionButton: pageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Provider.of<ChatroomHelpers>(context, listen: false)
                    .showCreateChatroomSheet(context: context);
              },
              backgroundColor: constantColors.blueGreyColor,
              child: Icon(
                FontAwesomeIcons.plus,
                color: constantColors.greenColor,
              ),
            )
          : Container(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: constantColors.darkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.moreVertical,
              color: constantColors.whiteColor,
            ),
          ),
        ],
        leading: pageIndex == 0
            ? IconButton(
                onPressed: () {
                  Provider.of<ChatroomHelpers>(context, listen: false)
                      .showCreateChatroomSheet(context: context);
                },
                icon: Icon(
                  FontAwesomeIcons.plus,
                  color: constantColors.greenColor,
                ),
              )
            : Container(),
        title: RichText(
          text: TextSpan(
            text: "Mared ",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Chatroom",
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
      body: PageView(
        controller: chatTypeController,
        children: const [
          GroupChats(),
          PrivateChats(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
    );
  }
}
