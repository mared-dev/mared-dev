import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';

class PopupUtils {
  static showSuccessPopup(
      {required String title,
      required String body,
      required BuildContext context}) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: title,
        text: body);
  }
}
