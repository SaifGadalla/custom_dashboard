import '../../../common.dart';

abstract class ServiceService {
  Future<Service?> create(Service service);
  Future<Service?> update(Service service);
  Future<void> delete(String id);
  Future<Service?> get(String id);
  Future<List<Service>> list(String? pageKey);
}
