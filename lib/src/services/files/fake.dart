import '../../../common.dart';

class FakeFileService implements FileService {
  final List<AppFile> files = [
    AppFile(
      id: '1',
      name: 'File 1',
      url: '',
      type: 'image',
      size: 1024,
      createdAt: DateTime.now(),
    ),
    AppFile(
      id: '2',
      name: 'File 2',
      url: '',
      type: 'image',
      size: 2048,
      createdAt: DateTime.now(),
    ),
    AppFile(
      id: '3',
      name: 'File 3',
      url: '',
      type: 'video',
      size: 1024,
      createdAt: DateTime.now(),
    ),
    AppFile(
      id: '4',
      name: 'File 2',
      url: '',
      type: 'video',
      size: 2048,
      createdAt: DateTime.now(),
    ),
    AppFile(
      id: '5',
      name: 'File 5',
      url: '',
      type: 'other',
      size: 1024,
      createdAt: DateTime.now(),
    ),
    AppFile(
      id: '6',
      name: 'File 6',
      url: '',
      type: 'other',
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
  Future<AppFile?> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingArticle = files.firstWhereOrNull((s) => s.id == id);
    if (existingArticle == null) {
      AppToast.show("Article not found");
      return null;
    }
    return existingArticle;
  }

  @override
  Future<List<AppFile>> list(String? pageKey, {String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered = (query == null || query.isEmpty)
        ? files
        : files
              .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    if (pageKey == null || pageKey.isEmpty) {
      return filtered.take(kPageSize).toList();
    }

    final cursorIndex = filtered.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= filtered.length) {
      return [];
    }
    return filtered.skip(cursorIndex + 1).take(kPageSize).toList();
  }

  @override
  Future<AppFile> upload(AppFile file) async {
    await Future.delayed(const Duration(seconds: 1));
    final newFile = file.copyWith(id: Uuid().v4(), createdAt: DateTime.now());
    files.add(newFile);
    return newFile;
  }
}
