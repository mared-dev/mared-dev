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
}
