import '../../common.dart';
import 'firestore_service.dart';

const env = String.fromEnvironment('env', defaultValue: 'dev');
bool get isReal => env == 'real';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

final aboutUsServiceProvider = Provider<AboutUsService>(
  (ref) => isReal
      ? RealAboutUsService(ref.read(firestoreServiceProvider))
      : FakeAboutUsService(),
);
final articleServiceProvider = Provider<ArticleService>(
  (ref) => isReal
      ? RealArticleService(ref.read(firestoreServiceProvider))
      : FakeArticleService(),
);
final authServiceProvider = Provider<AuthService>(
  (ref) => isReal ? RealAuthService() : FakeAuthService(),
);
final categoriesServiceProvider = Provider<CategoriesService>(
  (ref) => isReal
      ? RealCategoriesService(ref.read(firestoreServiceProvider))
      : FakeCategoriesService(),
);
final fileServiceProvider = Provider<FileService>(
  (ref) => isReal
      ? RealFileService(ref.read(firestoreServiceProvider))
      : FakeFileService(),
);
final serviceServiceProvider = Provider<ServiceService>(
  (ref) => isReal
      ? RealServiceService(ref.read(firestoreServiceProvider))
      : FakeServiceService(),
);
final imageUploadServiceProvider = Provider<ImageUploadService>(
  (ref) => isReal ? RealImageUploadService() : FakeImageUploadService(),
);
