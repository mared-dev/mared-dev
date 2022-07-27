import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    {required BuildContext context, required String markerString}) async {
  //String svgString1 = await DefaultAssetBundle.of(context).loadString('assets/icons/car_marker_icon.svg');
  late DrawableRoot svgDrawableRoot;
  svgDrawableRoot = await svg.fromSvgString(
    markerString,
    "",
  );
  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = 50 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 80 * devicePixelRatio; // same thing

  // Convert to ui.Picture
  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI

  ui.Image image = await picture.toImage(
    width.toInt(),
    height.toInt(),
  );
  ByteData? bytes = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  if (bytes == null) return BitmapDescriptor.defaultMarker;
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}
