import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import '../firestore_service.dart';

class RealServiceService extends ServiceService {
  final FirestoreService _fs;

  RealServiceService(this._fs);

  @override
  Future<Service?> create(Service service) async {
    final ref = _fs.appServices.doc();

    final newService = service.copyWith(
      id: ref.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.set(newService);
    return newService;
  }

  @override
  Future<Service?> update(Service service) async {
    final ref = _fs.appServices.doc(service.id);
    final updatedService = service.copyWith(updatedAt: DateTime.now());
    await ref.update(updatedService.toJson());
    return updatedService;
  }

  @override
  Future<void> delete(List<String> ids) async {
    final ref = _fs.appServices;
    await Future.wait(ids.map((id) => ref.doc(id).delete()));
  }

  @override
  Future<Service?> get(String id) async {
    final ref = _fs.appServices.doc(id);
    final doc = await ref.get();
    if (!doc.exists) {
      AppToast.show("Service not found");
      return null;
    } else {
      return doc.data();
    }
  }

  @override
  Future<List<Service>> list(String? pageKey, {String? query}) async {
    Query<Service> query_ = _fs.appServices.orderBy('name');

    // Prefix search on name
    if (query != null && query.isNotEmpty) {
      final end = query.substring(0, query.length - 1) +
          String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);
      query_ = query_
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: end);
    }

    query_ = query_.limit(kPageSize);

    if (pageKey?.isNotEmpty ?? false) {
      final cursorDoc = await _fs.appServices.doc(pageKey).get();
      query_ = query_.startAfterDocument(cursorDoc);
    }

    final snap = await query_.get();
    return snap.docs.map((doc) => doc.data()).toList();
  }
}
