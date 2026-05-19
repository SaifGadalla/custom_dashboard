import '../../../common.dart';

class FakeAboutUsService implements AboutUsService {
  // store about us in memory
  AboutUs _aboutUs = AboutUs(
    description: ['description'],
    mission: 'mission',
    vision: 'vision',
    imageUrl: 'imageUrl',
  );

  @override
  Future<AboutUs> get() async {
    await Future.delayed(const Duration(seconds: 1));
    return _aboutUs;
  }

  @override
  Future<void> update(AboutUs aboutUs) async {
    _aboutUs = _aboutUs.copyWith(
      description: aboutUs.description,
      mission: aboutUs.mission,
      vision: aboutUs.vision,
      imageUrl: aboutUs.imageUrl,
    );
  }
}
