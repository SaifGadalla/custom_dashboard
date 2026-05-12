import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';

@prod
@LazySingleton(as: ArticleService)
class RealArticleService extends ArticleService {
  @override
  Future<Article?> create(Article article) async {
    final ref = FirebaseFirestore.instance.collection('articles');
    final doc = ref.doc();

    final newArticle = article.copyWith(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await doc.set(newArticle.toJson());
    return newArticle;
  }

  @override
  Future<Article?> update(Article article) async {
    final ref = FirebaseFirestore.instance
        .collection('articles')
        .doc(article.id);
    final updatedArticle = article.copyWith(updatedAt: DateTime.now());
    await ref.update(updatedArticle.toJson());
    return updatedArticle;
  }

  @override
  Future<void> delete(String id) async {
    final ref = FirebaseFirestore.instance.collection('articles').doc(id);
    await ref.delete();
  }

  @override
  Future<Article?> get(String id) async {
    final ref = FirebaseFirestore.instance.collection('articles').doc(id);
    final doc = await ref.get();
    if (!doc.exists) {
      AppToast.show("Article not found");
      return null;
    } else {
      return Article.fromJson(doc.data()!);
    }
  }

  @override
  Future<List<Article>> list(String? pageKey) async {
    Query query = FirebaseFirestore.instance
        .collection('articles')
        .orderBy('createdAt')
        .limit(kPageSize);

    // pageKey is empty string on first load
    if (pageKey?.isNotEmpty ?? false) {
      // Fetch the cursor document, then paginate after it
      final cursorDoc = await FirebaseFirestore.instance
          .collection('articles')
          .doc(pageKey)
          .get();
      query = query.startAfterDocument(cursorDoc);
    }

    final snap = await query.get() as QuerySnapshot<Map<String, dynamic>>;
    return snap.docs.map((doc) => Article.fromJson(doc.data())).toList();
  }
}
