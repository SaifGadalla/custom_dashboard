import '../../../../common.dart';
import 'form/form.dart';

class AddOrEditCategoryDialogState {
  final bool isSubmitting;

  AddOrEditCategoryDialogState({this.isSubmitting = false});

  AddOrEditCategoryDialogState copyWith({bool? isSubmitting}) {
    return AddOrEditCategoryDialogState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

final addOrEditCategoryControllerProvider =
    NotifierProvider.family<
      AddOrEditCategoryDialogController,
      AddOrEditCategoryDialogState,
      Category?
    >(AddOrEditCategoryDialogController.new);

class AddOrEditCategoryDialogController
    extends Notifier<AddOrEditCategoryDialogState> {
  AddOrEditCategoryDialogController(this.initialValue);

  final Category? initialValue;

  CategoriesService get categoriesService =>
      ref.read(categoriesServiceProvider);

  @override
  AddOrEditCategoryDialogState build() {
    return AddOrEditCategoryDialogState();
  }

  bool get isEditing => initialValue != null;

  FormGroup get form => CategoryModelForm.toFormGroup(
    CategoryModelForm(id: initialValue?.id, name: initialValue?.name),
  );

  Future<void> updateAndReturnCategory(
    BuildContext context,
    FormGroup form,
  ) async {
    if (form.valid) {
      state = state.copyWith(isSubmitting: true);
      final model = CategoryModelForm.fromFormGroup(form);

      final newCategory = Category(
        id: isEditing ? initialValue!.id : const Uuid().v4(),
        name: model.name ?? '',
        createdAt: isEditing ? initialValue!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        if (isEditing) {
          await categoriesService.update(newCategory);
          if (context.mounted) {
            AppToast.show(context.l10n.edit_success);
          }
        } else {
          await categoriesService.create(newCategory);
          if (context.mounted) {
            AppToast.show(context.l10n.add_success);
          }
        }
        if (context.mounted) {
          Navigator.pop(context, newCategory);
        }
      } catch (e) {
        Logger('category dialog controller').shout(e.toString());
        if (context.mounted) {
          AppToast.show(e.toString());
        }
      } finally {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }
}
