import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeHelper {
  static String getElpasedTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    return timeago.format(dateTime);
  }
}
