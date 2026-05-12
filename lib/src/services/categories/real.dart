import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import 'base.dart';

@prod
@LazySingleton(as: CategoriesService)
class RealCategoriesService implements CategoriesService {
  @override
  Future<List<Category>> list(String? pageKey) async {
    Query query = FirebaseFirestore.instance
        .collection('categories')
        .orderBy('createdAt')
        .limit(kPageSize);

    // pageKey is empty string on first load
    if (pageKey?.isNotEmpty ?? false) {
      // Fetch the cursor document, then paginate after it
      final cursorDoc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(pageKey)
          .get();
      query = query.startAfterDocument(cursorDoc);
    }

    final snap = await query.get() as QuerySnapshot<Map<String, dynamic>>;
    return snap.docs.map((doc) => Category.fromJson(doc.data())).toList();
  }
}
