import '../../../common.dart';

@prod
@LazySingleton(as: FileService)
class RealFileService implements FileService {
  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<File?> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<File>> list(String? pageKey) {
    throw UnimplementedError();
  }

  @override
  Future<File> upload(File file) {
    throw UnimplementedError();
  }
}
