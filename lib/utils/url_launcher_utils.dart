import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<void> dialNumber(String phoneNumber) async {
    await launch('tel:$phoneNumber');
  }

  static Future<void> openWhatsapp(String phoneNumber) async {
    await launch('https://wa.me/$phoneNumber');
  }

  static Future<void> openWebsite(String link) async {
    await launch(link);
  }
}
