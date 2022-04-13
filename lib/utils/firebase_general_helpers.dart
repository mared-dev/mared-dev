class GeneralFirebaseHelpers {
  static String getStringSafely({required String key, required doc}) {
    String result = "";
    try {
      result = doc[key];
    } catch (e) {}
    return result;
  }
}
