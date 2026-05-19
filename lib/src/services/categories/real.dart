import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import '../firestore_service.dart';

class RealCategoriesService implements CategoriesService {
  final FirestoreService _fs;

  RealCategoriesService(this._fs);

  @override
  Future<List<Category>> list({String? pageKey, String? query}) async {
    Query<Category> query_ = _fs.categories.orderBy('name');

    // Prefix search on name
    if (query != null && query.isNotEmpty) {
      final end =
          query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);
      query_ = query_
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: end);
    }

    query_ = query_.limit(kPageSize);

    if (pageKey?.isNotEmpty ?? false) {
      final cursorDoc = await _fs.categories.doc(pageKey).get();
      query_ = query_.startAfterDocument(cursorDoc);
    }

    final snap = await query_.get();
    return snap.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<Category> get(String id) async {
    final doc = await _fs.categories.doc(id).get();
    if (!doc.exists) {
      throw Exception('Category not found');
    }
    return doc.data()!;
  }

  @override
  Future<void> create(Category category) async {
    await _fs.categories.doc(category.id).set(category);
  }

  @override
  Future<void> update(Category category) async {
    await _fs.categories
        .doc(category.id)
        .set(category, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String id) async {
    await _fs.categories.doc(id).delete();
  }
}
