class GeneralFirebaseHelpers {
  static String getStringSafely({required String key, required doc}) {
    String result = "";
    try {
      result = doc[key];
    } catch (e) {}
    return result;
  }

  static String getFormattedAuthError(e) {
    String result = e.toString();
    try {
      result = e.toString().split('] ')[1];
    } catch (e) {}
    return result;
  }
}
