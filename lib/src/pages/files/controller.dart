import '../../../common.dart';

class FilesState {
  FilesState({this.pageKey, required this.files, this.isLoading = false});
  final String? pageKey;
  final List<File> files;
  final bool isLoading;

  FilesState copyWith({List<File>? files, bool? isLoading, String? pageKey}) {
    return FilesState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final fileControllerProvider = NotifierProvider<FilesController, FilesState>(
  () => FilesController(getIt.get<FileService>()),
);

@lazySingleton
class FilesController extends Notifier<FilesState> {
  FilesController(this.fileService) : super();
  final FileService fileService;

  @override
  FilesState build() {
    return FilesState(files: []);
  }

  Future<List<File>> listFiles(String? pageKey) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final files = await fileService.list(pageKey);
      state = state.copyWith(files: files, pageKey: pageKey);
      return files;
    } catch (e) {
      Logger('files controller').shout(e.toString());
      return [];
    }
  }
}
