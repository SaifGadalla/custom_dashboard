import '../../../common.dart';

class ArticlesState {
  final String? pageKey;
  final bool isLoading;
  final List<Article> articles;

  ArticlesState({
    this.pageKey,
    this.isLoading = false,
    this.articles = const [],
  });

  ArticlesState copyWith({
    String? pageKey,
    bool? isLoading,
    List<Article>? articles,
  }) {
    return ArticlesState(
      pageKey: pageKey ?? this.pageKey,
      isLoading: isLoading ?? this.isLoading,
      articles: articles ?? this.articles,
    );
  }
}

final articleControllerProvider =
    NotifierProvider<ArticlesController, ArticlesState>(
      () => ArticlesController(),
    );

class ArticlesController extends Notifier<ArticlesState> {
  ArticleService get articleService => ref.read(articleServiceProvider);

  @override
  ArticlesState build() {
    return ArticlesState();
  }

  Future<List<Article>> listArticles({String? pageKey, String? query}) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final articles = await articleService.list(
        pageKey: pageKey,
        query: query,
      );
      state = state.copyWith(articles: articles, isLoading: false);
      return articles;
    } catch (e) {
      Logger('ArticlesController').shout(e.toString());
      state = state.copyWith(isLoading: false);
      return [];
    }
  }
}
