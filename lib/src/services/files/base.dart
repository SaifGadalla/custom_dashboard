import '../../../common.dart';

abstract class FileService {
  Future<File> upload(File file);
  Future<void> delete(String id);
  Future<File?> get(String id);
  Future<List<File>> list(String? pageKey);
}
