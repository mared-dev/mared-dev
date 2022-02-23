import 'package:meta/meta.dart';
import 'dart:convert';

AuctionCategories auctionCategoriesFromJson(String str) =>
    AuctionCategories.fromJson(json.decode(str));

String auctionCategoriesToJson(AuctionCategories data) =>
    json.encode(data.toJson());

class AuctionCategories {
  AuctionCategories({
    required this.name,
  });

  String name;

  factory AuctionCategories.fromJson(Map<String, dynamic> json) =>
      AuctionCategories(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
