import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import 'base.dart';

class FakeImageUploadService extends ImageUploadService {
  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    await Future.delayed(const Duration(seconds: 1));
    final id = const Uuid().v4();
    return 'https://fake-storage.example.com/images/$id-$fileName';
  }
}
