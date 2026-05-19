import 'dart:typed_data';

import '../../../../common.dart';
import 'form/form.dart';

class AddOrEditServiceDialogState {
  final bool isLoading;
  final bool isSubmitting;

  AddOrEditServiceDialogState({
    this.isLoading = false,
    this.isSubmitting = false,
  });

  AddOrEditServiceDialogState copyWith({bool? isLoading, bool? isSubmitting}) {
    return AddOrEditServiceDialogState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final addOrEditServiceControllerProvider =
    NotifierProvider.family<
      AddOrEditServiceDialogController,
      AddOrEditServiceDialogState,
      Service?
    >(AddOrEditServiceDialogController.new);

class AddOrEditServiceDialogController
    extends Notifier<AddOrEditServiceDialogState> {
  AddOrEditServiceDialogController(this.initialValue);

  final Service? initialValue;

  ImageUploadService get imageUploadService =>
      ref.read(imageUploadServiceProvider);
  ServiceService get servicesService => ref.read(serviceServiceProvider);

  @override
  AddOrEditServiceDialogState build() {
    return AddOrEditServiceDialogState();
  }

  bool get isEditing => initialValue != null;

  FormGroup get form => ServiceModelForm.toFormGroup(
    model: ServiceModelForm(
      name: initialValue?.name,
      details: initialValue?.details ?? [],
      image: initialValue?.imageUrl,
    ),
  );

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
      form.control(ServiceModelForm.imageControlName).value = downloadUrl;
      form.control(ServiceModelForm.imageControlName).markAsDirty();
    } catch (e) {
      Logger('service dialog controller').shout(e.toString());
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
      form.control(ServiceModelForm.imageControlName).value = downloadUrl;
      form.control(ServiceModelForm.imageControlName).markAsDirty();
    } catch (e) {
      Logger('service dialog controller').shout(e.toString());
      AppToast.show('Image upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateAndReturnAppService(
    BuildContext context,
    FormGroup form,
  ) async {
    if (form.valid) {
      state = state.copyWith(isSubmitting: true);
      final model = ServiceModelForm.fromFormGroup(form);

      final newService = Service(
        id: isEditing ? initialValue!.id : const Uuid().v4(),
        name: model.name ?? '',
        details: model.details,
        imageUrl: model.image ?? '',
        createdAt: isEditing ? initialValue!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        if (isEditing) {
          await servicesService.update(newService);
          if (context.mounted) {
            AppToast.show(context.l10n.edit_success);
          }
        } else {
          await servicesService.create(newService);
          if (context.mounted) {
            AppToast.show(context.l10n.add_success);
          }
        }
        if (context.mounted) {
          Navigator.pop(context, newService);
        }
      } catch (e) {
        Logger('service dialog controller').shout(e.toString());
        if (context.mounted) {
          AppToast.show(e.toString());
        }
      } finally {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }
}
