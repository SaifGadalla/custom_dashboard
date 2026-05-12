import 'dart:async';
import 'package:custom_dashboard/src/pages/services/add_or_edit_app_service/form/form.dart';

import '../../../../common.dart';

class AddOrEditAppServiceParams {
  final Service? initialValue;
  final Future<void> Function()? onSuccess;
  AddOrEditAppServiceParams({this.initialValue, this.onSuccess});
}

@injectable
class AddOrEditAppServiceDialogController {
  // extends BdayaCombinedController with UploadImageMixin {
  final FileService fileService;
  final ServiceService servicesService;
  final AddOrEditAppServiceParams parameters;

  AddOrEditAppServiceDialogController(
    this.fileService,
    this.servicesService,
    @factoryParam this.parameters,
  );

  FormGroup get form => ServiceModelForm.toFormGroup(
    model: ServiceModelForm(
      name: parameters.initialValue?.name,
      details: parameters.initialValue?.details ?? [],
      image: parameters.initialValue?.imageUrl,
    ),
  );

  // final initialModelRx = SharedValue<ServiceModel?>(value: null);
  // final formRx = SharedValue<ServiceModelForm?>(value: null);
  // final idRx = SharedValue<String?>(value: null);

  /// Tracks the storageRef when a new image is selected.
  // final pendingStorageRefRx = SharedValue<String?>(value: null);

  // late final saveLA = withLoadableArea(
  //   name: 'services-edit-save-la',
  //   isLoading: false,
  // );

  bool get isEditing => parameters.initialValue != null;

  // FormArray<Map<String, Object?>>? get detailsFA => formRx.$?.detailsControl;

  // final selectedDetailsControlsRx =
  //     SharedValue<List<AbstractControl<Map<String, Object?>>>>(value: []);

  // @override
  // void beforeRender(BuildContext context) {
  //   super.beforeRender(context);
  //   initializeModel();
  // }

  // void initializeModel() async {
  //   final initialValue = parameters.initialValue;
  //   initialModelRx.$ = ServiceModel(
  //     name: fillLocalesArrays(initialValue?.serviceName.locales),
  //     details: fillNestedArrays(
  //       initialValue?.details.map((e) => e.locales).toList() ?? [],
  //     ),
  //     image: initialValue?.imageUrl.value,
  //     status: initialValue?.status ?? Status.STATUS_PUBLISHED,
  //   );
  //   formRx.$?.form.markAsPristine();
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
  //     pageId: 'services',
  //     l10n: context.l10n,
  //   );
  // }

  // Future<void> getImg({required S l10n}) async {
  //   final res = await callGuard<f.GetResponse>(
  //     () async => await fileService.get(f.GetRequest(key: idRx.$)),
  //     l10n: l10n,
  //     logger: logger,
  //   );
  //   if (res != null) {
  //     // Use storageRef instead of signed URL - backend will generate fresh URLs on-demand
  //     formRx.$?.imageControl.value = res.details.storageRef.value;
  //   }
  // }

  // Future<void> updateItemInNestedFA({
  //   required List<MapEntry<String, String>> value,
  //   int? index,
  //   required FormArray<Map<String, Object?>>? fa,
  // }) async {
  //   if (fa == null) return;
  //   if (index == null) {
  //     fa.add(LocalesArrayForm.formElements(LocalesArray(locales: value)));
  //     return;
  //   }
  //   final fg = fa.control(index.toString()) as FormGroup;
  //   final localesControl = fg.control('locales') as FormArray<LocaleEntry>;
  //   localesControl.reset(value: value);
  // }

  // Future<void> updateAndReturnAppService(BuildContext context) async {
  //   if (formRx.$!.form.valid) {
  //     final model = formRx.$!.model;

  //     // Use pendingStorageRefRx if a new image was selected, otherwise use form value
  //     final imageUrlToSave = pendingStorageRefRx.$ ?? model.image;

  //     var newService = ChangeBase(
  //       serviceName: SetLocalizedText(locales: model.name ?? []),
  //       details: model.details.map(
  //         (e) => SetLocalizedText(locales: e.locales ?? []),
  //       ),
  //       imageUrl: imageUrlToSave,
  //       status: model.status,
  //       isShown: isEditing ? parameters.initialValue?.isShown : false,
  //     );

  //     if (isEditing) {
  //       final res = await callGuard<UpdateResponse>(
  //         () async => await servicesService.update(
  //           UpdateRequest(
  //             key: parameters.initialValue?.id,
  //             changes: newService,
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
  //         }
  //       }

  //       await parameters.onSuccess?.call();
  //     } else {
  //       final res = await callGuard<CreateResponse>(
  //         () async =>
  //             await servicesService.create(CreateRequest(changes: newService)),
  //         l10n: context.l10n,
  //         logger: logger,
  //         la: saveLA,
  //         startLa: true,
  //         stopLa: true,
  //       );
  //       if (res != null) {
  //         if (context.mounted) {
  //           AppToast.show(context.l10n.add_success);
  //         }
  //       }

  //       await parameters.onSuccess?.call();
  //     }
  //     if (context.mounted) {
  //       Navigator.pop(context, newService);
  //     }
  //   }
  // }

  // void onSelectAllDetails(bool? value) {
  //   if (value == true) {
  //     selectedDetailsControlsRx.$ = detailsFA?.controls ?? [];
  //   } else {
  //     selectedDetailsControlsRx.$ = [];
  //   }
  // }

  // @override
  // FutureOr<void> Function(f.GetResponse res) get onSuccess => (res) {
  //   pendingStorageRefRx.$ = res.details.storageRef.value;
  //   formRx.$?.imageControl.value = res.details.url;
  //   formRx.$?.imageControl.markAsDirty();
  // };

  // @override
  // FileService get service => fileService;
}
