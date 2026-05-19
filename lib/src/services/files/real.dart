import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import '../firestore_service.dart';

class RealFileService implements FileService {
  final FirestoreService _fs;

  RealFileService(this._fs);

  @override
  Future<void> delete(String id) async {
    await _fs.mediaLibraryImages.doc(id).delete();
  }

  @override
  Future<AppFile?> get(String id) async {
    final doc = await _fs.mediaLibraryImages.doc(id).get();
    return doc.data();
  }

  @override
  Future<List<AppFile>> list(String? pageKey, {String? query}) async {
    Query<AppFile> query_ = _fs.mediaLibraryImages.orderBy('name');

    if (query != null && query.isNotEmpty) {
      final end = query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);
      query_ = query_
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: end);
    }

    query_ = query_.limit(kPageSize);

    if (pageKey?.isNotEmpty ?? false) {
      final cursorDoc = await _fs.mediaLibraryImages.doc(pageKey).get();
      query_ = query_.startAfterDocument(cursorDoc);
    }

    final snap = await query_.get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<AppFile> upload(AppFile file) async {
    final ref = _fs.mediaLibraryImages.doc();
    final newFile = file.copyWith(id: ref.id);
    await ref.set(newFile);
    return newFile;
  }
}
