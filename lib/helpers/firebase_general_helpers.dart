import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralFirebaseHelpers {
  static String getStringSafely({required String key, required doc}) {
    String result = "";
    try {
      result = doc[key];
    } catch (e) {}
    return result;
  }

  static GeoPoint getGeoPointSafely({required String key, required doc}) {
    GeoPoint result = const GeoPoint(0, 0);
    try {
      String stringForm = doc[key];
      result = stringToGeopoint(stringForm);
    } catch (e) {}
    return result;
  }

  static String geoPointToString(GeoPoint geoPoint) {
    String result = "0,0";
    try {
      result = '${geoPoint.latitude},${geoPoint.longitude}';
    } catch (e) {
      print(e);
    }
    return result;
  }

  static GeoPoint stringToGeopoint(String location) {
    try {
      GeoPoint result = GeoPoint(double.parse(location.split(',')[0]),
          double.parse(location.split(',')[1]));
      return result;
    } catch (e) {
      print('@@@@@@@@@@@@@@@@@');
      print(e);
      return GeoPoint(0, 0);
    }
  }

  static String getFormattedAuthError(e) {
    String result = e.toString();
    try {
      result = e.toString().split('] ')[1];
    } catch (e) {}
    return result;
  }

  static bool validateMobile(String value) {
    String pattern = r'^(?:\+971|00971|0)?(?:50|51|52|55|56|2|3|4|6|7|9)\d{7}$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static List<String> generateIndices(String text) {
    String paddedText = "$text ";

    List<String> splitList = paddedText.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length; j++) {
        indexList.add(splitList[i].substring(0, j + 1).toLowerCase());
      }
    }
    return indexList;
  }
}
