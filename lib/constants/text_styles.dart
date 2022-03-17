import 'package:flutter/material.dart';

TextStyle regularTextStyle(
    {required double fontSize,
    required Color textColor,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    overflow: overflow,
    fontFamily: "Montserrat",
  );
}

TextStyle lightTextStyle(
    {required double fontSize,
    required Color textColor,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return TextStyle(
      color: textColor,
      fontSize: fontSize,
      overflow: overflow,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w300);
}

TextStyle semiBoldTextStyle(
    {required double fontSize,
    required Color textColor,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return TextStyle(
      color: textColor,
      fontSize: fontSize,
      overflow: overflow,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600);
}
