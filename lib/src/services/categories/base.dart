import '../../../common.dart';

abstract class CategoriesService {
  Future<List<Category>> list(String? pageKey);
}
