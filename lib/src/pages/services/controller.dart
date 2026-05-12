import '../../../common.dart';

class ServiceState {
  ServiceState({this.pageKey, required this.services, this.isLoading = false});
  final String? pageKey;
  final List<Service> services;
  final bool isLoading;

  ServiceState copyWith({
    String? pageKey,
    List<Service>? services,
    bool? isLoading,
  }) {
    return ServiceState(
      pageKey: pageKey ?? this.pageKey,
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final serviceControllerProvider =
    NotifierProvider<ServicesController, ServiceState>(
  () => ServicesController(getIt.get<ServiceService>()),
);

@lazySingleton
class ServicesController extends Notifier<ServiceState> {
  ServicesController(this.serviceService);
  final ServiceService serviceService;

  @override
  ServiceState build() {
    return ServiceState(services: []);
  }

  Future<List<Service>> listServices(String? pageKey) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final services = await serviceService.list(pageKey);
      state = state.copyWith(services: services, pageKey: pageKey);
      return services;
    } catch (e) {
      Logger('service controller').shout(e.toString());
      return [];
    }
  }
}
