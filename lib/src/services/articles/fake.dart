import '../../../common.dart';

@dev
@LazySingleton(as: ArticleService)
class FakeArticleService extends ArticleService {
  final List<Article> articles = List.generate(
    5,
    (index) => Article(
      id: index.toString(),
      title: 'Article $index',
      content: 'Detail $index',
      imageUrl: '',
      category: Category(
        id: '1',
        name: 'Category 1',
        image: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Future<Article?> create(Article article) async {
    await Future.delayed(const Duration(seconds: 1));
    final newArticle = article.copyWith(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    articles.add(newArticle);
    return newArticle;
  }

  @override
  Future<Article?> update(Article article) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingArticle = articles.firstWhereOrNull(
      (s) => s.id == article.id,
    );
    if (existingArticle == null) {
      AppToast.show("Article not found");
      return null;
    }
    final newArticle = existingArticle.copyWith(updatedAt: DateTime.now());
    articles.remove(existingArticle);
    articles.add(newArticle);
    return newArticle;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingArticle = articles.firstWhereOrNull((s) => s.id == id);
    if (existingArticle == null) {
      AppToast.show("Article not found");
    }
    articles.remove(existingArticle);
  }

  @override
  Future<Article?> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingArticle = articles.firstWhereOrNull((s) => s.id == id);
    if (existingArticle == null) {
      AppToast.show("Article not found");
      return null;
    }
    return existingArticle;
  }

  @override
  Future<List<Article>> list(String? pageKey) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // First page: no cursor
    if (pageKey == null || pageKey.isEmpty) {
      return articles.take(kPageSize).toList();
    }

    // Find the cursor index and return items after it
    final cursorIndex = articles.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= articles.length) {
      return [];
    }
    return articles.skip(cursorIndex + 1).take(kPageSize).toList();
  }
}
