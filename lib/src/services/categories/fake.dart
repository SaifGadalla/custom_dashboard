import '../../../common.dart';
import 'base.dart';

@dev
@LazySingleton(as: CategoriesService)
class FakeCategoriesService implements CategoriesService {
  @override
  Future<List<Category>> list(String? pageKey) {
    return Future.value([
      Category(
        id: '1',
        name: 'Category 1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        image: '',
      ),
      Category(
        id: '2',
        name: 'Category 2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        image: '',
      ),
    ]);
  }
}
