import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/LandingPage/landingpage.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class IsAnonHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chatbox.png"),
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
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: RichText(
          text: TextSpan(
            text: "Sign Up ",
            style: TextStyle(
              fontFamily: "Poppins",
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "With Mared\n",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              TextSpan(
                text: "Experience the Magic",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.73,
      left: 10,
      right: 10,
      child: InkWell(
        onTap: () async {
          await Provider.of<Authentication>(context, listen: false)
              .logOutViaEmail()
              .whenComplete(() {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: LandingPage(),
                    type: PageTransitionType.bottomToTop));
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: constantColors.greenColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            "Let me login",
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
