import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';

@prod
@LazySingleton(as: ServiceService)
class RealServiceService extends ServiceService {
  @override
  Future<Service?> create(Service service) async {
    final ref = FirebaseFirestore.instance.collection('services');
    final doc = ref.doc();

    final newService = service.copyWith(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await doc.set(newService.toJson());
    return newService;
  }

  @override
  Future<Service?> update(Service service) async {
    final ref = FirebaseFirestore.instance
        .collection('services')
        .doc(service.id);
    final updatedService = service.copyWith(updatedAt: DateTime.now());
    await ref.update(updatedService.toJson());
    return updatedService;
  }

  @override
  Future<void> delete(String id) async {
    final ref = FirebaseFirestore.instance.collection('services').doc(id);
    await ref.delete();
  }

  @override
  Future<Service?> get(String id) async {
    final ref = FirebaseFirestore.instance.collection('services').doc(id);
    final doc = await ref.get();
    if (!doc.exists) {
      AppToast.show("Service not found");
      return null;
    } else {
      return Service.fromJson(doc.data()!);
    }
  }

  @override
  Future<List<Service>> list(String? pageKey) async {
    Query query = FirebaseFirestore.instance
        .collection('services')
        .orderBy('createdAt')
        .limit(kPageSize);

    // pageKey is empty string on first load
    if (pageKey?.isNotEmpty ?? false) {
      // Fetch the cursor document, then paginate after it
      final cursorDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(pageKey)
          .get();
      query = query.startAfterDocument(cursorDoc);
    }

    final snap = await query.get() as QuerySnapshot<Map<String, dynamic>>;
    return snap.docs.map((doc) => Service.fromJson(doc.data())).toList();
  }
}
