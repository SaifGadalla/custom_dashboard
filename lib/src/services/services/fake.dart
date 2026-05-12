import '../../../common.dart';

@dev
@LazySingleton(as: ServiceService)
class FakeServiceService extends ServiceService {
  final List<Service> services = List.generate(
    5,
    (index) => Service(
      id: index.toString(),
      name: 'Service $index',
      details: [],
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
    final existingService = services.firstWhereOrNull(
      (s) => s.id == service.id,
    );
    if (existingService == null) {
      AppToast.show("Service not found");
      return null;
    }
    final newService = existingService.copyWith(updatedAt: DateTime.now());
    services.remove(existingService);
    services.add(newService);
    return newService;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final existingService = services.firstWhereOrNull((s) => s.id == id);
    if (existingService == null) {
      AppToast.show("Service not found");
    }
    services.remove(existingService);
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
  Future<List<Service>> list(String? pageKey) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // First page: no cursor
    if (pageKey == null || pageKey.isEmpty) {
      return services.take(kPageSize).toList();
    }

    // Find the cursor index and return items after it
    final cursorIndex = services.indexWhere((s) => s.id == pageKey);
    if (cursorIndex == -1 || cursorIndex + 1 >= services.length) {
      return [];
    }
    return services.skip(cursorIndex + 1).take(kPageSize).toList();
  }
}
