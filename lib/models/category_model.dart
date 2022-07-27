import 'package:flutter/material.dart';

class CategoryModel {
  final String categoryId;
  final String categoryImage;
  final String categoryName;
  final Color color;
  final String markerIconText;
  dynamic mapIconDescriptor;

  CategoryModel(
      {required this.categoryId,
      required this.categoryImage,
      required this.categoryName,
      required this.markerIconText,
      this.mapIconDescriptor,
      required this.color});
}
