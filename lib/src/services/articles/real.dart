import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import '../firestore_service.dart';

class RealArticleService extends ArticleService {
  final FirestoreService _fs;

  RealArticleService(this._fs);

  @override
  Future<Article?> create(Article article) async {
    final ref = _fs.articles.doc();

    final newArticle = article.copyWith(
      id: ref.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.set(newArticle);
    return newArticle;
  }

  @override
  Future<Article?> update(Article article) async {
    final ref = _fs.articles.doc(article.id);
    final updatedArticle = article.copyWith(updatedAt: DateTime.now());
    await ref.update(updatedArticle.toJson());
    return updatedArticle;
  }

  @override
  Future<void> delete(String id) async {
    final ref = _fs.articles.doc(id);
    await ref.delete();
  }

  @override
  Future<Article?> get(String id) async {
    final ref = _fs.articles.doc(id);
    final doc = await ref.get();
    if (!doc.exists) {
      AppToast.show("Article not found");
      return null;
    } else {
      return doc.data();
    }
  }

  @override
  Future<List<Article>> list({String? pageKey, String? query}) async {
    Query<Article> query_ = _fs.articles.orderBy('title');

    // Prefix search on title
    if (query != null && query.isNotEmpty) {
      final end = query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);
      query_ = query_
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: end);
    }

    query_ = query_.limit(kPageSize);

    if (pageKey?.isNotEmpty ?? false) {
      final cursorDoc = await _fs.articles.doc(pageKey).get();
      query_ = query_.startAfterDocument(cursorDoc);
    }

    final snap = await query_.get();
    return snap.docs.map((doc) => doc.data()).toList();
  }
}
