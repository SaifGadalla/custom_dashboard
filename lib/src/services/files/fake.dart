import '../../../common.dart';

@dev
@LazySingleton(as: FileService)
class FakeFileService implements FileService {
  final List<File> files = [
    File(
      id: '1',
      name: 'File 1',
      url: '',
      type: 'image',
      size: 1024,
      createdAt: DateTime.now(),
    ),
    File(
      id: '2',
      name: 'File 2',
      url: '',
      type: 'image',
      size: 2048,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingFile = files.firstWhereOrNull((s) => s.id == id);
    if (existingFile == null) {
      AppToast.show("File not found");
    }
    files.remove(existingFile);
  }

  @override
  Future<File?> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingArticle = files.firstWhereOrNull((s) => s.id == id);
    if (existingArticle == null) {
      AppToast.show("Article not found");
      return null;
    }
    return existingArticle;
  }

  @override
  Future<List<File>> list(String? pageKey) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // First page: no cursor
    if (pageKey == null || pageKey.isEmpty) {
      return files.take(kPageSize).toList();
    }

    // Find the cursor index and return items after it
    final cursorIndex = files.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= files.length) {
      return [];
    }
    return files.skip(cursorIndex + 1).take(kPageSize).toList();
  }

  @override
  Future<File> upload(File file) async {
    await Future.delayed(const Duration(seconds: 1));
    final newFile = file.copyWith(id: Uuid().v4(), createdAt: DateTime.now());
    files.add(newFile);
    return newFile;
  }
}
