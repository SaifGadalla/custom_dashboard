import '../../../../../common.dart';

class CategoryModelForm {
  CategoryModelForm({this.id, this.name, this.createdAt, this.updatedAt});

  CategoryModelForm copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModelForm(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const String idControlName = 'id';
  static const String nameControlName = 'name';
  static const String createdAtControlName = 'createdAt';
  static const String updatedAtControlName = 'updatedAt';

  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static FormGroup toFormGroup(CategoryModelForm model) {
    return FormGroup({
      idControlName: FormControl<String>(value: model.id),
      nameControlName: FormControl<String>(
        value: model.name,
        validators: [Validators.required],
      ),
      createdAtControlName: FormControl<DateTime>(value: model.createdAt),
      updatedAtControlName: FormControl<DateTime>(value: model.updatedAt),
    });
  }

  static CategoryModelForm fromFormGroup(FormGroup formGroup) {
    return CategoryModelForm(
      id: formGroup.control(idControlName).value,
      name: formGroup.control(nameControlName).value,
      createdAt: formGroup.control(createdAtControlName).value,
      updatedAt: formGroup.control(updatedAtControlName).value,
    );
  }
}
