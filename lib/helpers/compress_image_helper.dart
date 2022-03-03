import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CompressImageHelper {
  static Future<File> compressImageAndGetFile(File file) async {
    final imageUri = Uri.parse(file.path);
    final String outputUri = imageUri.resolve('./output.webp').toString();
    print(imageUri.toFilePath());

    File? compressed = await FlutterImageCompress.compressAndGetFile(
        file.path, outputUri,
        quality: 85, format: CompressFormat.webp);

    print('************ design alog output ****************');
    print(file.lengthSync());
    print(compressed!.lengthSync());

    return compressed;
  }
}
