import '../../../common.dart';

abstract class FileService {
  Future<AppFile> upload(AppFile file);
  Future<void> delete(String id);
  Future<AppFile?> get(String id);
  Future<List<AppFile>> list(String? pageKey, {String? query});
}
