
import 'package:image_picker/image_picker.dart';

class PickFilesHelper{
  static final ImagePicker picker=ImagePicker();

  static Future<XFile?> pickVide({ImageSource source=ImageSource.gallery})async{
    var video=await picker
        .pickVideo(source: source);

    return video;
  }

  static Future<XFile?> pickImage({ImageSource source=ImageSource.gallery})async{
    var image=await picker
        .pickImage(source: source);

    return image;
  }



  static Future<List<XFile>> multiImagePicker() async {
    List<XFile>? _images = await picker.pickMultiImage();
    if (_images != null && _images.isNotEmpty) {
      return _images;
    }
    return [];
  }
}