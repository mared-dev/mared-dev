import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/checkout/StripeCheckout.dart';
import 'package:mared_social/checkout/server_stub.dart';
import 'package:mared_social/checkout/stripe_checkout.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/promotePost/promotePostHelper.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PromotePost extends StatefulWidget {
  @override
  State<PromotePost> createState() => _PromotePostState();
}

class _PromotePostState extends State<PromotePost> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Provider.of<PromotePostHelper>(context, listen: false)
          .appBar(context),
      body: Provider.of<PromotePostHelper>(context, listen: false)
          .listPosts(context),
    );
  }
}
