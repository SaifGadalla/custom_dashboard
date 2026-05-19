import 'package:custom_dashboard/src/pages/services/add_or_edit_app_service/dialog.dart';

import '../../../common.dart';

class ServiceState {
  ServiceState({
    this.pageKey,
    this.services = const [],
    this.isLoading = false,
  });
  final String? pageKey;
  final List<Service> services;
  final bool isLoading;

  ServiceState copyWith({
    String? pageKey,
    List<Service>? services,
    bool? isLoading,
  }) {
    return ServiceState(services: services ?? this.services);
  }
}

final serviceControllerProvider =
    NotifierProvider<ServicesController, ServiceState>(
      () => ServicesController(),
    );

class ServicesController extends Notifier<ServiceState> {
  ServiceService get serviceService => ref.read(serviceServiceProvider);

  @override
  ServiceState build() {
    return ServiceState(services: []);
  }

  Future<List<Service>> listServices({String? pageKey, String? query}) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final services = await serviceService.list(pageKey, query: query);
      state = state.copyWith(services: services, isLoading: false);
      return services;
    } catch (e) {
      Logger('service controller').shout(e.toString());
      state = state.copyWith(isLoading: false);
      return [];
    }
  }

  Future<void> deleteServices(
    BuildContext context,
    List<Service> services, {
    required VoidCallback onSuccess,
  }) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await serviceService.delete(services.map((e) => e.id).toList());
      final newServices = state.services
          .where((s) => !services.contains(s))
          .toList();
      state = state.copyWith(services: newServices, isLoading: false);
      onSuccess();
    } catch (e) {
      Logger('service controller').shout(e.toString());
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addOrEditService(
    BuildContext context,
    Service? service,
    VoidCallback onSuccess,
  ) async {
    await AddOrEditAppServiceDialog.show(context, service);
    onSuccess();
  }
}
