import 'package:custom_dashboard/common.dart';

class ServiceModelForm {
  static const String nameControlName = 'name';
  static const String detailsControlName = 'details';
  static const String imageControlName = 'image';
  static const String createdAtControlName = 'createdAt';
  static const String updatedAtControlName = 'updatedAt';

  final String? name;
  final List<String> details;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceModelForm({
    this.name,
    this.details = const [],
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  ServiceModelForm copyWith({
    String? name,
    List<String>? details,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModelForm(
      name: name ?? this.name,
      details: details ?? this.details,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static FormGroup toFormGroup({ServiceModelForm? model}) {
    return FormGroup({
      nameControlName: FormControl<String>(value: model?.name),
      detailsControlName: FormArray<String>(
        model?.details.map((e) => FormControl<String>(value: e)).toList() ?? [],
      ),
      imageControlName: FormControl<String>(value: model?.image),
      createdAtControlName: FormControl<DateTime>(value: model?.createdAt),
      updatedAtControlName: FormControl<DateTime>(value: model?.updatedAt),
    });
  }

  static ServiceModelForm fromFormGroup(FormGroup formGroup) {
    return ServiceModelForm(
      name: formGroup.control(nameControlName).value,
      details: formGroup.control(detailsControlName).value,
      image: formGroup.control(imageControlName).value,
      createdAt: formGroup.control(createdAtControlName).value,
      updatedAt: formGroup.control(updatedAtControlName).value,
    );
  }
}

// import 'package:reactive_forms_annotations/reactive_forms_annotations.dart';

// part 'form.gform.dart';

// @Rf()
// class ServiceModel {
//   final String? name;
//   final List<String> details;
//   final String? image;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   ServiceModel({
//     @RfControl(validators: [RequiredValidator()]) this.name,
//     @RfArray<String>(validators: [FormArrayMinLengthValidator(1)])
//     this.details = const [],
//     @RfControl(validators: [RequiredValidator()]) this.image,
//     @RfControl(validators: [RequiredValidator()]) this.createdAt,
//     @RfControl(validators: [RequiredValidator()]) this.updatedAt,
//   });
// }

// class FormArrayMinLengthValidator extends Validator<String> {
//   final int minLength;
//   const FormArrayMinLengthValidator(this.minLength) : super();

//   @override
//   Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
//     if (control.value == null) {
//       return null;
//     }

//     List<dynamic>? collection;

//     if (control is FormArray<dynamic>) {
//       collection = control.value;
//     }

//     return (collection != null && collection.length >= minLength)
//         ? null
//         : <String, dynamic>{
//             ValidationMessage.minLength: {
//               'requiredLength': minLength,
//               'actualLength': collection != null ? collection.length : 0,
//             },
//           };
//   }
// }
