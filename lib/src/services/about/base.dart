import '../../../common.dart';

abstract class AboutUsService {
  Future<void> update(AboutUs aboutUs);
  Future<AboutUs> get();
}
