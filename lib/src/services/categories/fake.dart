import '../../../common.dart';

class FakeCategoriesService implements CategoriesService {
  final List<Category> _categories = List.generate(
    10,
    (index) => Category(
      id: index.toString(),
      name: 'Category $index',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Future<List<Category>> list({String? pageKey, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered = (query == null || query.isEmpty)
        ? _categories
        : _categories
              .where(
                (c) =>
                    (c.name ?? '').toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

    if (pageKey == null || pageKey.isEmpty) {
      return filtered.take(kPageSize).toList();
    }

    final cursorIndex = filtered.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= filtered.length) return [];
    return filtered.skip(cursorIndex + 1).take(kPageSize).toList();
  }

  @override
  Future<Category> get(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _categories.indexWhere((c) => c.id == id);
    if (index == -1) {
      throw Exception('Category not found');
    }
    return _categories[index];
  }

  @override
  Future<void> create(Category category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _categories.add(category);
  }

  @override
  Future<void> update(Category category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _categories.removeWhere((c) => c.id == id);
  }
}
