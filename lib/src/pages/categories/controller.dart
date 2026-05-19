import '../../../common.dart';

class CategoriesState {
  final List<Category> categories;
  final bool isLoading;

  CategoriesState({this.categories = const [], this.isLoading = false});

  CategoriesState copyWith({List<Category>? categories, bool? isLoading}) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final categoriesControllerProvider =
    NotifierProvider<CategoriesController, CategoriesState>(
      () => CategoriesController(),
    );

class CategoriesController extends Notifier<CategoriesState> {
  CategoriesService get categoriesService =>
      ref.read(categoriesServiceProvider);

  @override
  CategoriesState build() {
    return CategoriesState();
  }

  Future<List<Category>> listCategories({
    String? pageKey,
    String? query,
  }) async {
    state = state.copyWith(isLoading: true);
    final categories = await categoriesService.list(
      pageKey: pageKey,
      query: query,
    );
    state = state.copyWith(categories: categories, isLoading: false);
    return categories;
  }
}
