import '../../../common.dart';

abstract class ArticleService {
  Future<Article?> create(Article article);
  Future<Article?> update(Article article);
  Future<void> delete(String id);
  Future<Article?> get(String id);
  Future<List<Article>> list({String? pageKey, String? query});
}
