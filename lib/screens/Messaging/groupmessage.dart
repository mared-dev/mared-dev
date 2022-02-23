import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/Messaging/groupmessagehelper.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  ConstantColors constantColors = ConstantColors();
  TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<GroupMessageHelper>(context, listen: false)
        .checkIfJoined(
            context: context,
            chatroomId: widget.documentSnapshot.id,
            chatroomAdminUid: widget.documentSnapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessageHelper>(context, listen: false)
              .getHasMemberJoined ==
          false) {
        Timer(
          const Duration(milliseconds: 10),
          () =>
              Provider.of<GroupMessageHelper>(context, listen: false).askToJoin(
            context: context,
            roomname: widget.documentSnapshot['roomname'],
            chatroomId: widget.documentSnapshot.id,
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<GroupMessageHelper>(context, listen: false)
                  .leaveTheRoom(
                context: context,
                documentSnapshot: widget.documentSnapshot,
              );
            },
            icon: Icon(EvaIcons.logInOutline, color: constantColors.redColor),
          ),
          Provider.of<Authentication>(context, listen: false).getUserId ==
                  widget.documentSnapshot['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
        ),
        backgroundColor: constantColors.darkColor,
        centerTitle: false,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot['roomAvatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot['roomname'],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(widget.documentSnapshot.id)
                          .collection("members")
                          .snapshots(),
                      builder: (context, memberSnaps) {
                        if (memberSnaps.data!.docs.isEmpty) {
                          return Text(
                            "0 Members",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        } else {
                          return Text(
                            "${memberSnaps.data!.docs.length} Members",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AnimatedContainer(
                color: constantColors.darkColor,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessageHelper>(context, listen: false)
                    .showMessages(
                        context: context,
                        documentSnapshot: widget.documentSnapshot,
                        adminUserUid: widget.documentSnapshot['useruid']),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: constantColors.blueGreyColor,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<GroupMessageHelper>(context,
                                  listen: false)
                              .showSticker(
                            context: context,
                            chatroomId: widget.documentSnapshot.id,
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Email cannot be blank' : null,
                            // onSaved: (value) => _email = value,

                            controller: messageController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: "Drop a hi...",
                              hintStyle: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: constantColors.blueColor,
                        onPressed: () async {
                          if (_formKey.currentState!.validate() == true) {
                            String messageId = nanoid(14).toString();
                            await Provider.of<GroupMessageHelper>(context,
                                    listen: false)
                                .sendMessage(
                              context: context,
                              documentSnapshot: widget.documentSnapshot,
                              messagecontroller: messageController,
                              messageId: messageId,
                            );

                            await Provider.of<GroupMessageHelper>(context,
                                    listen: false)
                                .updateTime(
                                    documentSnapshot: widget.documentSnapshot);

                            messageController.clear();
                          }
                        },
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
                        ),
                      ),
                    ],
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
