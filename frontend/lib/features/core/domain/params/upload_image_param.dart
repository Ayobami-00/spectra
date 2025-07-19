import 'dart:io';

import 'dart:typed_data';

class UploadImageParam {
  final File? imageFile;
  final String imagePath;
  Uint8List? uint8listData;

  UploadImageParam({
    this.imageFile,
    required this.imagePath,
    this.uint8listData,
  });

  UploadImageParam copyWith({
    File? imageFile,
    String? imagePath,
    Uint8List? uint8listData,
  }) {
    return UploadImageParam(
      imageFile: imageFile ?? this.imageFile,
      imagePath: imagePath ?? this.imagePath,
      uint8listData: uint8listData ?? this.uint8listData,
    );
  }
}
