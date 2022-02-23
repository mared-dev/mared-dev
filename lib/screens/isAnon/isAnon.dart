import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/isAnon/isAnonHelper.dart';
import 'package:provider/provider.dart';

class IsAnonMsg extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  IsAnonMsg({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<IsAnonHelper>(context, listen: false).bodyImage(context),
          Provider.of<IsAnonHelper>(context, listen: false)
              .taglineText(context),
          Provider.of<IsAnonHelper>(context, listen: false).mainButton(context),
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 0.9],
          colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ],
        ),
      ),
    );
  }
}
