import 'dart:async';
import '../../../common.dart';

class HomeState {
  final List<Article> articles;
  final List<Service> services;
  final List<AppFile> files;
  final AboutUs aboutUs;
  final bool isLoading;

  HomeState({
    this.articles = const [],
    this.services = const [],
    this.files = const [],
    required this.aboutUs,
    this.isLoading = false,
  });

  HomeState copyWith({
    List<Article>? articles,
    List<Service>? services,
    List<AppFile>? files,
    AboutUs? aboutUs,
    bool? isLoading,
  }) {
    return HomeState(
      articles: articles ?? this.articles,
      services: services ?? this.services,
      files: files ?? this.files,
      aboutUs: aboutUs ?? this.aboutUs,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final homeProvider = NotifierProvider<HomeController, HomeState>(
  () => HomeController(),
);

class HomeController extends Notifier<HomeState> {
  ArticleService get articlesService => ref.read(articleServiceProvider);
  ServiceService get servicesService => ref.read(serviceServiceProvider);
  FileService get filesService => ref.read(fileServiceProvider);
  AboutUsService get aboutUsService => ref.read(aboutUsServiceProvider);

  @override
  HomeState build() {
    Future.microtask(init);
    return HomeState(
      aboutUs: AboutUs(description: [], imageUrl: '', mission: '', vision: ''),
    );
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    await Future.wait([getArticles(), getServices(), getFiles(), getAboutUs()]);
    state = state.copyWith(isLoading: false);
  }

  Future<void> getArticles() async {
    try {
      final articles = await articlesService.list(pageKey: null, query: null);
      state = state.copyWith(articles: articles);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getServices() async {
    try {
      final services = await servicesService.list(null);
      state = state.copyWith(services: services);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getFiles() async {
    try {
      final files = await filesService.list(null);
      state = state.copyWith(files: files);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> getAboutUs() async {
    try {
      final aboutUs = await aboutUsService.get();
      state = state.copyWith(aboutUs: aboutUs);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refresh() async {
    await init();
  }
}
