import '../../../common.dart';

abstract class CategoriesService {
  Future<List<Category>> list({String? pageKey, String? query});
  Future<Category> get(String id);
  Future<void> create(Category category);
  Future<void> update(Category category);
  Future<void> delete(String id);
}
