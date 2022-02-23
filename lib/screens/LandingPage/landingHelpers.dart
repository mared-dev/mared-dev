import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/LandingPage/landingServices.dart';
import 'package:mared_social/screens/LandingPage/landingUtils.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.png"),
        ),
      ),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.59,
      left: 10,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 190,
        ),
        child: RichText(
          text: TextSpan(
              text: "Connecting\n",
              style: TextStyle(
                fontFamily: "Poppins",
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Businesses\n",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                TextSpan(
                  text: "In UAE",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.79,
      right: 10,
      left: 10,
      child: Platform.isIOS
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginIcon(
                    icon: EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                    onTap: () => emailAuthSheet(context),
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                    onTap: () async {
                      try {
                        await Provider.of<Authentication>(context,
                                listen: false)
                            .signInWithgoogle();

                        String name =
                            "${Provider.of<Authentication>(context, listen: false).getgoogleUsername} ";

                        List<String> splitList = name.split(" ");
                        List<String> indexList = [];

                        for (int i = 0; i < splitList.length; i++) {
                          for (int j = 0; j < splitList[i].length; j++) {
                            indexList.add(
                                splitList[i].substring(0, j + 1).toLowerCase());
                          }
                        }

                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .createUserCollection(context, {
                          'usercontactnumber': Provider.of<Authentication>(
                                  context,
                                  listen: false)
                              .getgooglePhoneNo,
                          'usersearchindex': indexList,
                          'store': false,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserId,
                          'useremail': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUseremail,
                          'username': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUsername,
                          'userimage': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUserImage,
                        });

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: SplitPages(),
                                type: PageTransitionType.rightToLeft));
                      } catch (e) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Sign In Failed",
                          text: e.toString(),
                        );
                      }
                    },
                  ),
                  // LoginIcon(
                  //   icon: EvaIcons.facebook,
                  //   color: constantColors.blueColor,
                  // ),
                  LoginIcon(
                      icon: FontAwesomeIcons.apple,
                      onTap: () async {
                        try {
                          await Provider.of<Authentication>(context,
                                  listen: false)
                              .signInWithApple(context)
                              .whenComplete(() async {
                            String name =
                                "${Provider.of<Authentication>(context, listen: false).getappleUsername} ";

                            List<String> splitList = name.split(" ");
                            List<String> indexList = [];

                            for (int i = 0; i < splitList.length; i++) {
                              for (int j = 0; j < splitList[i].length; j++) {
                                indexList.add(splitList[i]
                                    .substring(0, j + 1)
                                    .toLowerCase());
                              }
                            }

                            await Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              'usercontactnumber': "No Number",
                              'store': false,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                              'usersearchindex': indexList,
                              'useremail': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getappleUseremail,
                              'username': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getappleUsername,
                              'userimage': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getappleUserImage,
                            });

                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: SplitPages(),
                                    type: PageTransitionType.rightToLeft));
                          });
                        } catch (e) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: "Sign In Failed",
                            text: e.toString(),
                          );
                        }
                      },
                      color: constantColors.whiteColor)
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginIcon(
                    icon: EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                    onTap: () => emailAuthSheet(context),
                  ),
                  LoginIcon(
                    icon: EvaIcons.google,
                    color: constantColors.greenColor,
                    onTap: () async {
                      try {
                        await Provider.of<Authentication>(context,
                                listen: false)
                            .signInWithgoogle();

                        String name =
                            "${Provider.of<Authentication>(context, listen: false).getgoogleUsername} ";

                        List<String> splitList = name.split(" ");
                        List<String> indexList = [];

                        for (int i = 0; i < splitList.length; i++) {
                          for (int j = 0; j < splitList[i].length; j++) {
                            indexList.add(
                                splitList[i].substring(0, j + 1).toLowerCase());
                          }
                        }

                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .createUserCollection(context, {
                          'usercontactnumber': Provider.of<Authentication>(
                                  context,
                                  listen: false)
                              .getgooglePhoneNo,
                          'store': false,
                          'usersearchindex': indexList,
                          'useruid': Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserId,
                          'useremail': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUseremail,
                          'username': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUsername,
                          'userimage': Provider.of<Authentication>(context,
                                  listen: false)
                              .getgoogleUserImage,
                        });

                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: SplitPages(),
                                type: PageTransitionType.rightToLeft));
                      } catch (e) {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Sign In Failed",
                          text: e.toString(),
                        );
                      }
                    },
                  ),
                  // LoginIcon(
                  //   icon: EvaIcons.facebook,
                  //   color: constantColors.blueColor,
                  // ),
                ],
              ),
            ),
    );
  }

  Widget exploreApp(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.84,
      left: 20,
      right: 20,
      child: InkWell(
        onTap: () async {
          try {
            String anonUsername = nanoid(10).toString();
            await Provider.of<Authentication>(context, listen: false)
                .signInAnon();

            String name = "$anonUsername";

            List<String> splitList = name.split(" ");
            List<String> indexList = [];

            for (int i = 0; i < splitList.length; i++) {
              for (int j = 0; j < splitList[i].length; j++) {
                indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
              }
            }

            await Provider.of<FirebaseOperations>(context, listen: false)
                .createUserCollection(context, {
              'usercontactnumber': "",
              'store': false,
              'useruid':
                  Provider.of<Authentication>(context, listen: false).getUserId,
              'useremail': "$anonUsername@mared.ae",
              'username': "@$anonUsername",
              'usersearchindex': indexList,
              'userimage':
                  "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/userProfileAvatar%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2Ficon-mared.png?alt=media&token=eec2b470-f32e-4449-874a-e6929e210c6c",
            });

            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: SplitPages(), type: PageTransitionType.rightToLeft));
          } catch (e) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Sign In Failed",
              text: e.toString(),
            );
          }
        },
        child: Column(
          children: [
            Divider(
              color: constantColors.lightColor,
            ),
            Container(
              alignment: Alignment.center,
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: constantColors.lightBlueColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "I want to explore Mared first",
                style: TextStyle(
                  color: constantColors.lightBlueColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.92,
      left: 20,
      right: 20,
      child: Column(
        children: const [
          Text(
            "By continuing you agree to Mareds Terms of",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            "Services & Privacy Policy",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passwordlessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<LandingService>(context, listen: false)
                            .loginSheet(context);
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: constantColors.redColor,
                      onPressed: () async {
                        Navigator.pop(context);
                        Provider.of<LandingUtils>(context, listen: false)
                            .selectAvatarOptionsSheet(context);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoginIcon extends StatelessWidget {
  const LoginIcon({
    Key? key,
    required this.color,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(icon, color: color),
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
