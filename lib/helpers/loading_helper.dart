import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingHelper {
  static startLoading({String loadingText = 'loading...'}) {
    EasyLoading.show(status: loadingText);
  }

  static endLoading() {
    EasyLoading.dismiss();
  }
}
