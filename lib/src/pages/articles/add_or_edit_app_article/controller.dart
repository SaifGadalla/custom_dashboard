import 'dart:typed_data';

import '../../../../common.dart';

import 'form/form.dart';

class AddOrEditArticleDialogState {
  final List<Category> categories;
  final bool isLoading;
  final bool isSubmitting;
  final bool isInitialized;

  AddOrEditArticleDialogState({
    this.categories = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.isInitialized = false,
  });

  AddOrEditArticleDialogState copyWith({
    List<Category>? categories,
    bool? isLoading,
    bool? isSubmitting,
    bool? isInitialized,
  }) {
    return AddOrEditArticleDialogState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

final addOrEditArticleControllerProvider =
    NotifierProvider.family<
      AddOrEditArticleDialogController,
      AddOrEditArticleDialogState,
      Article?
    >(AddOrEditArticleDialogController.new);

class AddOrEditArticleDialogController
    extends Notifier<AddOrEditArticleDialogState> {
  AddOrEditArticleDialogController(this.initialValue);

  final Article? initialValue;

  ImageUploadService get imageUploadService =>
      ref.read(imageUploadServiceProvider);
  CategoriesService get categoriesService =>
      ref.read(categoriesServiceProvider);
  ArticleService get articlesService => ref.read(articleServiceProvider);

  @override
  AddOrEditArticleDialogState build() {
    form = ArticleModelForm.toFormGroup(
      ArticleModelForm(
        id: initialValue?.id,
        title: initialValue?.title,
        content: initialValue?.content,
        imageUrl: initialValue?.imageUrl,
        category: initialValue?.category,
      ),
    );
    
    // Start fetching categories in the background
    getCategories();
    
    return AddOrEditArticleDialogState();
  }

  late final FormGroup form;

  Future<void> getCategories() async {
    // Optionally set isLoading to true if you want to show a spinner somewhere
    final categories = await categoriesService.list();
    state = state.copyWith(categories: categories);
  }

  bool get isEditing => initialValue != null;

  /// Picks an image file and uploads it, then sets the download URL on the form.
  Future<void> pickAndUploadImage(FormGroup form) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final downloadUrl = await imageUploadService.uploadImage(
        bytes,
        file.name,
      );
      form.control(ArticleModelForm.imageUrlControlName).value = downloadUrl;
      form.control(ArticleModelForm.imageUrlControlName).markAsDirty();
    } catch (e) {
      Logger('article dialog controller').shout(e.toString());
      AppToast.show('Image upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Uploads a drag-dropped file and sets the URL on the form.
  Future<void> handleDragUpload(
    Uint8List bytes,
    String fileName,
    FormGroup form,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final downloadUrl = await imageUploadService.uploadImage(bytes, fileName);
      form.control(ArticleModelForm.imageUrlControlName).value = downloadUrl;
      form.control(ArticleModelForm.imageUrlControlName).markAsDirty();
    } catch (e) {
      Logger('article dialog controller').shout(e.toString());
      AppToast.show('Image upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateAndReturnArticle(
    BuildContext context,
    FormGroup form,
  ) async {
    if (form.valid) {
      state = state.copyWith(isSubmitting: true);
      final model = ArticleModelForm.fromFormGroup(form);

      final newArticle = Article(
        id: isEditing ? initialValue!.id : const Uuid().v4(),
        title: model.title ?? '',
        content: model.content ?? '',
        imageUrl: model.imageUrl ?? '',
        category: model.category ?? Category(),
        createdAt: isEditing ? initialValue!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        if (isEditing) {
          await articlesService.update(newArticle);
          if (context.mounted) {
            AppToast.show(context.l10n.edit_success);
          }
        } else {
          await articlesService.create(newArticle);
          if (context.mounted) {
            AppToast.show(context.l10n.add_success);
          }
        }
        if (context.mounted) {
          Navigator.pop(context, newArticle);
        }
      } catch (e) {
        Logger('article dialog controller').shout(e.toString());
        if (context.mounted) {
          AppToast.show(e.toString());
        }
      } finally {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }
}
