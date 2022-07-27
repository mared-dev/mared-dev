import 'package:flutter/material.dart';
import 'package:mared_social/screens/isAnon/isAnon.dart';

IsAnonBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return SafeArea(
        bottom: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: IsAnonMsg(),
        ),
      );
    },
  );
}
