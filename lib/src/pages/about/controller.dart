import 'dart:typed_data';

import 'package:custom_dashboard/common.dart';

class AboutState {
  final bool isLoading;
  final bool isSubmitting;
  AboutState({this.isLoading = false, this.isSubmitting = false});

  AboutState copyWith({bool? isLoading, bool? isSubmitting}) {
    return AboutState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final aboutControllerProvider = NotifierProvider<AboutController, AboutState>(
  AboutController.new,
);

class AboutController extends Notifier<AboutState> {
  AboutController();

  final form = FormGroup({
    'vision': FormControl<String>(validators: [Validators.required]),
    'mission': FormControl<String>(validators: [Validators.required]),
    'description': FormArray<String>([]),
    'imageUrl': FormControl<String>(validators: [Validators.required]),
  });

  ImageUploadService get imageUploadService => ref.read(imageUploadServiceProvider);

  @override
  AboutState build() {
    _init();
    return AboutState();
  }

  Future<void> _init() async {
    // Avoid modifying state directly in build by deferring it
    Future.microtask(() async {
      state = state.copyWith(isLoading: true);
      try {
        final aboutUs = await ref.read(aboutUsServiceProvider).get();
        form.control('vision').value = aboutUs.vision;
        form.control('mission').value = aboutUs.mission;
        form.control('imageUrl').value = aboutUs.imageUrl;
        
        final descriptionArray = form.control('description') as FormArray<String>;
        descriptionArray.clear();
        for (final desc in aboutUs.description) {
          descriptionArray.add(FormControl<String>(value: desc));
        }
      } catch (e) {
        // Handle error
      } finally {
        state = state.copyWith(isLoading: false);
      }
    });
  }

  Future<void> save() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }
    
    state = state.copyWith(isSubmitting: true);
    try {
      final descriptionControls = (form.control('description') as FormArray<String>).controls;
      final descriptions = descriptionControls.map((c) => c.value ?? '').where((s) => s.isNotEmpty).toList();
      
      final aboutUs = AboutUs(
        vision: form.control('vision').value as String,
        mission: form.control('mission').value as String,
        imageUrl: form.control('imageUrl').value as String,
        description: descriptions,
      );
      
      await ref.read(aboutUsServiceProvider).update(aboutUs);
      AppToast.show('Saved successfully');
    } catch (e) {
      AppToast.show('Error saving');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  Future<void> pickAndUploadImage() async {
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
      final downloadUrl = await imageUploadService.uploadImage(bytes, file.name);
      form.control('imageUrl').value = downloadUrl;
      form.control('imageUrl').markAsDirty();
    } catch (e) {
      AppToast.show('Image upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> handleDragUpload(Uint8List bytes, String fileName) async {
    state = state.copyWith(isLoading: true);
    try {
      final downloadUrl = await imageUploadService.uploadImage(bytes, fileName);
      form.control('imageUrl').value = downloadUrl;
      form.control('imageUrl').markAsDirty();
    } catch (e) {
      AppToast.show('Image upload failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
