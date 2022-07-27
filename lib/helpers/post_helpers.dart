import 'package:image_picker/image_picker.dart';

class PostHelpers {
  static bool checkIfPostIsVideo(List<dynamic> files) {
    return files.length == 1 && files[0].contains('.m3u8');
  }
}
