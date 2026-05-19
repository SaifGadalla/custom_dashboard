import '../../../common.dart';

class FakeServiceService extends ServiceService {
  final List<Service> services = List.generate(
    5,
    (index) => Service(
      id: index.toString(),
      name: 'Service $index',
      details: ["detail $index 1", "detail $index 2", "detail $index 3"],
      imageUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Future<Service?> create(Service service) async {
    await Future.delayed(const Duration(seconds: 1));
    final newService = service.copyWith(
      id: Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    services.add(newService);
    return newService;
  }

  @override
  Future<Service?> update(Service service) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingIndex = services.indexWhere((s) => s.id == service.id);
    if (existingIndex == -1) {
      AppToast.show("Service not found");
      return null;
    }
    final updatedService = service.copyWith(updatedAt: DateTime.now());
    services[existingIndex] = updatedService;
    return updatedService;
  }

  @override
  Future<void> delete(List<String> ids) async {
    await Future.delayed(const Duration(seconds: 1));
    services.removeWhere((s) => ids.contains(s.id));
  }

  @override
  Future<Service?> get(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingService = services.firstWhereOrNull((s) => s.id == id);
    if (existingService == null) {
      AppToast.show("Service not found");
      return null;
    }
    return existingService;
  }

  @override
  Future<List<Service>> list(String? pageKey, {String? query}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final filtered = (query == null || query.isEmpty)
        ? services
        : services
              .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    if (pageKey == null || pageKey.isEmpty) {
      return filtered.take(kPageSize).toList();
    }

    final cursorIndex = filtered.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= filtered.length) {
      return [];
    }
    return filtered.skip(cursorIndex + 1).take(kPageSize).toList();
  }
}
