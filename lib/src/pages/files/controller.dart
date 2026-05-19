import '../../../common.dart';

class FilesState {
  FilesState({
    this.pageKey,
    this.files = const [],
    this.statisticsFiles = const [],
    this.isLoading = false,
  });
  final String? pageKey;
  final List<AppFile> files;
  final List<AppFile> statisticsFiles;
  final bool isLoading;

  FilesState copyWith({
    List<AppFile>? files,
    List<AppFile>? statisticsFiles,
    bool? isLoading,
    String? pageKey,
  }) {
    return FilesState(
      files: files ?? this.files,
      statisticsFiles: statisticsFiles ?? this.statisticsFiles,
      isLoading: isLoading ?? this.isLoading,
      pageKey: pageKey ?? this.pageKey,
    );
  }
}

final fileControllerProvider = NotifierProvider<FilesController, FilesState>(
  () => FilesController(),
);

class FilesController extends Notifier<FilesState> {
  FileService get fileService => ref.read(fileServiceProvider);
  ImageUploadService get imageUploadService => ref.read(imageUploadServiceProvider);

  @override
  FilesState build() {
    return FilesState(files: []);
  }

  Future<List<AppFile>> listFiles(String? pageKey, {String? query}) async {
    if (state.isLoading) return [];
    state = state.copyWith(isLoading: true);
    try {
      final results = await fileService.list(pageKey, query: query);
      if ((query == null || query.isEmpty) &&
          (pageKey == null || pageKey.isEmpty)) {
        state = state.copyWith(
          files: results,
          statisticsFiles: results,
          isLoading: false,
        );
      } else {
        state = state.copyWith(files: results, isLoading: false);
      }
      return results;
    } catch (e) {
      Logger('files controller').shout(e.toString());
      state = state.copyWith(isLoading: false);
      return [];
    }
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final url = await imageUploadService.uploadImage(file.bytes!, file.name);

      final appFile = AppFile(
        id: '',
        name: file.name,
        url: url,
        type: file.extension == 'jpg' || file.extension == 'png' || file.extension == 'jpeg' ? 'image' : 
              file.extension == 'mp4' || file.extension == 'mov' ? 'video' : 'other',
        size: file.size,
        createdAt: DateTime.now(),
      );

      await fileService.upload(appFile);
      AppToast.show('File uploaded successfully');
    } catch (e) {
      Logger('files controller').shout(e.toString());
      AppToast.show('Upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
