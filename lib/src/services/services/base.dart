import '../../../common.dart';

abstract class ServiceService {
  Future<Service?> create(Service service);
  Future<Service?> update(Service service);
  Future<void> delete(List<String> ids);
  Future<Service?> get(String id);
  Future<List<Service>> list(String? pageKey, {String? query});
}
