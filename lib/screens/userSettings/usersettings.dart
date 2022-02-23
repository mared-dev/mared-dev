import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/promotePost/promotePost.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserSettingsPage extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text(
          "My Settings",
          style: TextStyle(
            color: constantColors.whiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getInitUserImage,
                          height: size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListTileOption(
                  constantColors: constantColors,
                  onTap: () {},
                  leadingIcon: FontAwesomeIcons.userAlt,
                  trailingIcon: Icons.arrow_forward_ios_outlined,
                  text: "User Details",
                ),
              ),
              ListTileOption(
                constantColors: constantColors,
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: PromotePost(),
                          type: PageTransitionType.rightToLeft));
                },
                leadingIcon: Icons.star_border_outlined,
                trailingIcon: Icons.arrow_forward_ios_outlined,
                text: "Promote Post",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
