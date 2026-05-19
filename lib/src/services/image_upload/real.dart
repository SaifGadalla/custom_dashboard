import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'base.dart';

class RealImageUploadService extends ImageUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final ext = fileName.split('.').last;
    final uniqueName = '${const Uuid().v4()}.$ext';
    final path = 'images/$uniqueName';

    // We assume a bucket named 'images' exists in Supabase.
    // If the user's bucket is named differently, this should be updated.
    await _supabase.storage.from('images').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$ext'),
        );

    final publicUrl = _supabase.storage.from('images').getPublicUrl(path);
    return publicUrl;
  }
}
