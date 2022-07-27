//TODO:fetch later from firebase

import 'package:flutter/material.dart';

import 'category_model.dart';

Map<String, CategoryModel> categories = {
  'Business & Industry': CategoryModel(
      categoryId: 'D3E3jov4eMASTA',
      markerIconText: 'assets/icons/map_markers/1.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fbuisness_industry.png?alt=media&token=54a58f6f-60c1-45d5-935b-9c7a613431c7",
      categoryName: 'Business & Industry',
      color: Color(0xFFFF00A8EA)),
  'Jobs': CategoryModel(
      categoryId: 'JplnlhO5MALYNG',
      markerIconText: 'assets/icons/map_markers/2.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fjobs.png?alt=media&token=b5a58040-b6c9-4216-a480-a1b09faeaf38",
      categoryName: 'Jobs',
      color: Color(0xFFFF00D1AB)),
  "Furniture": CategoryModel(
      categoryId: 'REk4LDul2WBteH',
      markerIconText: 'assets/icons/map_markers/3.png',
      categoryImage:
          'https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Ffurniture.png?alt=media&token=d7bf2427-2742-404e-ad3d-37606e45741d',
      categoryName: 'Furniture',
      color: Color(0xFFFFFF6360)),
  "Healthcare": CategoryModel(
      categoryId: 'Sjqu-DcpmBIIk6',
      markerIconText: 'assets/icons/map_markers/4.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fhealth_care.png?alt=media&token=42a0f370-5fd3-4e9a-8e72-151cc49087a1",
      categoryName: 'Healthcare',
      color: Color(0xFFFFB064FC)),
  "Sports": CategoryModel(
      categoryId: 'TfvKyo5ttCXPo-',
      markerIconText: 'assets/icons/map_markers/5.png',
      categoryImage:
          '"https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fsports.png?alt=media&token=5ec75f99-1d60-4810-a4b6-d2f8a6cebe02"',
      categoryName: 'Sports',
      color: Color(0xFFFF00C400)),
  "Education": CategoryModel(
      categoryId: '_HjzlrbM-qIXfl',
      markerIconText: 'assets/icons/map_markers/6.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Feducation.png?alt=media&token=d90bc8ac-4b7c-4a76-bec7-61cb35bced92",
      categoryName: 'Education',
      color: Color(0xFFFF007CCB)),
  'Services': CategoryModel(
      categoryId: '_oBSruZsYoCP8e',
      markerIconText: 'assets/icons/map_markers/7.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fservices.png?alt=media&token=dcbfe9a0-2ecb-429b-82bd-832814584ff6",
      categoryName: 'Services',
      color: Color(0xFFFFA7D300)),
  "Homemade": CategoryModel(
      categoryId: 'a1MvEutB5OeRmH',
      markerIconText: 'assets/icons/map_markers/8.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fhome_made.png?alt=media&token=2d861edd-d816-44b0-bc0e-3f71fe23e1d4",
      categoryName: 'Homemade',
      color: Color(0xFFFFFFBC51)),
  "Electronics": CategoryModel(
      categoryId: 'j0qaFwEF7ghQPv',
      markerIconText: 'assets/icons/map_markers/9.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Felectronics.png?alt=media&token=c7ea310e-560d-4d7f-b882-379098cad778",
      categoryName: 'Electronics',
      color: Color(0xFFFF159762)),
  "Fashion & Beauty": CategoryModel(
      categoryId: 'rb8JwP_Udtpz8a',
      markerIconText: 'assets/icons/map_markers/10.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Ffashion_beauty.png?alt=media&token=22d4b767-19fe-4b11-aed3-4824598b4e65",
      categoryName: 'Fashion & Beauty',
      color: Color(0xFFFFFF4DAC)),
  "Real Estate": CategoryModel(
      categoryId: 's_hOLR_RGlxHBp',
      markerIconText: 'assets/icons/map_markers/11.png',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Freal_estate.png?alt=media&token=4232feef-e0a3-416c-a3db-138a5bb04d23",
      categoryName: 'Real Estate',
      color: Color(0xFFFFFF5321)),
  "Automobiles": CategoryModel(
      categoryId: 'tEDkGfbx4bQEwY',
      categoryImage:
          "https://firebasestorage.googleapis.com/v0/b/maredsocial-79a7b.appspot.com/o/categories%2Fauto_mobiles.png?alt=media&token=19faf2cf-6d07-4168-99b7-e7d4c3a67d24",
      categoryName: 'Automobiles',
      markerIconText: 'assets/icons/map_markers/12.png',
      color: Color(0xFFFFFF4463))
};
