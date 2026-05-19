import 'dart:typed_data';

/// Abstraction for uploading image bytes and getting back a download URL.
abstract class ImageUploadService {
  /// Uploads [bytes] as [fileName] and returns the public download URL.
  Future<String> uploadImage(Uint8List bytes, String fileName);
}
