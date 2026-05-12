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
    return ArticlesState(articles: articles ?? this.articles);
  }
}

final articleControllerProvider =
    NotifierProvider<ArticlesController, ArticlesState>(
      () => ArticlesController(getIt.get<ArticleService>()),
    );

@lazySingleton
class ArticlesController extends Notifier<ArticlesState> {
  ArticlesController(this.articleService);
  final ArticleService articleService;

  @override
  ArticlesState build() {
    return ArticlesState();
  }

  Future<List<Article>> listArticles({String? pageKey}) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final articles = await articleService.list(pageKey);
      state = state.copyWith(articles: articles, isLoading: false);
      return articles;
    } catch (e) {
      Logger('ArticlesController').shout(e.toString());
      state = state.copyWith(isLoading: false);
      return [];
    }
  }
}
