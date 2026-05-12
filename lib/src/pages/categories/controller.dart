import '../../../common.dart';

import '../../services/categories/base.dart';

final categoriesControllerProvider =
    NotifierProvider<CategoriesController, List<Category>>(
  () => CategoriesController(getIt.get<CategoriesService>()),
);

@lazySingleton
class CategoriesController extends Notifier<List<Category>> {
  CategoriesController(this.categoriesService);
  final CategoriesService categoriesService;

  @override
  List<Category> build() {
    return [];
  }

  Future<List<Category>> listCategories(String? pageKey) async {
    return await categoriesService.list(pageKey);
  }
}
