import 'dart:async';

import '../../../../common.dart';

import '../../../services/categories/base.dart';
import 'form/form.dart';

class AddOrEditArticleDialogParams {
  final Article? initialValue;
  Future<void> Function()? onSuccess;
  AddOrEditArticleDialogParams({this.initialValue, this.onSuccess});
}

@injectable
class AddOrEditArticleDialogController extends Notifier<Article> {
  final FileService fileService;
  final CategoriesService categoriesService;
  final ArticleService articlesService;
  final AddOrEditArticleDialogParams parameters;

  AddOrEditArticleDialogController(
    @factoryParam this.parameters,
    this.fileService,
    this.articlesService,
    this.categoriesService,
  );

  bool get isEditing => parameters.initialValue != null;

  FormGroup get form => ArticleModelForm.toFormGroup(
    ArticleModelForm(
      id: parameters.initialValue?.id,
      title: parameters.initialValue?.title,
      content: parameters.initialValue?.content,
      imageUrl: parameters.initialValue?.imageUrl,
      category: parameters.initialValue?.category,
    ),
  );

  // final initialModelRx = SharedValue<ArticlesModel?>(value: null);
  // final formRx = SharedValue<ArticlesModelForm?>(value: null);
  // final newCategoryInitialModelRx = SharedValue<LocaleEntryModel?>(
  //   value: LocaleEntryModel(
  //     fillLocalesArrays({}),
  //   ),
  // );
  // final newCategoryFormRx = SharedValue<LocaleEntryModelForm?>(value: null);
  // final categoriesRx = SharedValue<List<Category>>(value: []);
  // final idRx = SharedValue<String?>(value: null);
  // final addedCategory = SharedValue<Category?>(value: null);

  // /// Tracks the storageRef when a new image is selected.
  // final pendingStorageRefRx = SharedValue<String?>(value: null);

  // final isAddingCategory = SharedValue<bool>(value: false);

  // late final la =
  //     withLoadableArea(name: 'articles-edit-controller', isLoading: false);
  // late final saveLA =
  //     withLoadableArea(name: 'articles-edit-save-la', isLoading: false);

  // S get l10n => getIt<LocalizationsService>().l10n;

  // bool get isEditing => parameters.initialValue != null;

  // @override
  // void beforeRender(BuildContext context) {
  //   super.beforeRender(context);
  //   init();
  // }

  // Future<void> init() async {
  //   la.startLoading();
  //   await getCategories();
  //   initializeModel();
  //   la.stopLoadingSuccess();
  // }

  // void initializeModel() async {
  //   final initialValue = parameters.initialValue;
  //   Category? initialCategory = initialValue?.category;
  //   if (initialCategory != null) {
  //     initialCategory = categoriesRx.$
  //             .where((c) => c.id == initialCategory!.id)
  //             .firstOrNull ??
  //         initialCategory;
  //   }
  //   initialModelRx.$ = ArticlesModel(
  //     category: initialCategory,
  //     article: fillLocalesArrays(initialValue?.article.locales),
  //     headline: fillLocalesArrays(initialValue?.headline.locales),
  //     imageUrl: initialValue?.imageUrl.value,
  //     shortText: fillLocalesArrays(initialValue?.shortText.locales),
  //     status: initialValue?.status ?? Status.STATUS_PUBLISHED,
  //   );
  //   formRx.$?.form.markAsPristine();
  // }

  // Future<void> getCategories() async {
  //   final res = await callGuard<c.ListResponse>(
  //       () async => await categoriesService.list(c.ListRequest()),
  //       l10n: l10n,
  //       logger: logger);
  //   categoriesRx.$ = res?.data ?? [];
  // }

  // Future<void> addCategory(Map<String, String> value, {required S l10n}) async {
  //   final res = await callGuard<c.CreateResponse>(
  //     () async => await categoriesService.create(
  //       c.CreateRequest(
  //         changes: c.ChangeBase(
  //           categoryName: SetLocalizedText(
  //             locales: value.entries,
  //           ),
  //         ),
  //       ),
  //     ),
  //     l10n: l10n,
  //     logger: logger,
  //     la: saveLA,
  //     startLa: true,
  //     stopLa: true,
  //   );

  //   if (res != null) {
  //     AppToast.show(l10n.add_success);
  //     await getCategories();
  //     final newCategory =
  //         categoriesRx.$.where((c) => c.id == res.details.id).firstOrNull;
  //     addedCategory.$ = newCategory ?? res.details;
  //   }
  // }

  // Future<void> dropZoneUploadImage({
  //   required String fileName,
  //   required List<int> data,
  //   required BuildContext context,
  //   String? mimetype,
  // }) async {
  //   await uploadImage(
  //     mimeType: mimetype,
  //     file: PlatformFile(
  //       name: fileName,
  //       size: data.length,
  //       bytes: Uint8List.fromList(data),
  //     ),
  //     la: saveLA,
  //     l10n: context.l10n,
  //     pageId: 'articles',
  //   );
  // }

  // Future<void> getImg({required S l10n}) async {
  //   final res = await callGuard<f.GetResponse>(
  //       () async => await fileService.get(
  //             f.GetRequest(
  //               key: idRx.$,
  //             ),
  //           ),
  //       l10n: l10n,
  //       logger: logger);
  //   if (res != null) {
  //     formRx.$?.imageUrlControl.value = res.details.storageRef.value;
  //   }
  // }

  // Future<void> updateAndReturnArticle(BuildContext context) async {
  //   if (formRx.$!.form.valid) {
  //     final model = formRx.$!.model;

  //     final imageUrlToSave = pendingStorageRefRx.$ ?? model.imageUrl;

  //     var newPieceofArticles = ChangeBase(
  //       headline: SetLocalizedText(locales: model.headline ?? []),
  //       categoryId: model.category?.id,
  //       imageUrl: imageUrlToSave,
  //       article: SetLocalizedText(locales: model.article ?? []),
  //       shortText: SetLocalizedText(locales: model.shortText ?? []),
  //       status: model.status,
  //       isShown: isEditing ? parameters.initialValue?.isShown : false,
  //     );

  //     if (isEditing) {
  //       final res = await callGuard<UpdateResponse>(
  //         () async => await articlesService.update(
  //           UpdateRequest(
  //             key: parameters.initialValue?.id,
  //             changes: newPieceofArticles,
  //           ),
  //         ),
  //         l10n: context.l10n,
  //         logger: logger,
  //         la: saveLA,
  //         startLa: true,
  //         stopLa: true,
  //       );
  //       if (res != null) {
  //         if (context.mounted) {
  //           AppToast.show(context.l10n.edit_success);
  //           await parameters.onSuccess?.call();
  //         }
  //       }
  //     } else {
  //       final res = await callGuard<CreateResponse>(
  //         () async => await articlesService.create(
  //           CreateRequest(
  //             changes: newPieceofArticles,
  //           ),
  //         ),
  //         l10n: context.l10n,
  //         logger: logger,
  //         la: saveLA,
  //         startLa: true,
  //         stopLa: true,
  //       );
  //       if (res != null) {
  //         if (context.mounted) {
  //           AppToast.show(context.l10n.add_success);
  //           await parameters.onSuccess?.call();
  //         }
  //       }
  //     }

  //     if (context.mounted) {
  //       Navigator.pop(context);
  //     }
  //   }
  // }

  // @override
  // FutureOr<void> Function(f.GetResponse res) get onSuccess => (res) {
  //       // Store storageRef for saving to backend
  //       pendingStorageRefRx.$ = res.details.storageRef.value;
  //       // Set displayUrl to form for preview
  //       formRx.$?.imageUrlControl.value = res.details.url;
  //       formRx.$?.imageUrlControl.markAsDirty();
  //     };

  // @override
  // FileService get service => fileService;

  @override
  Article build() {
    throw UnimplementedError();
  }
}
