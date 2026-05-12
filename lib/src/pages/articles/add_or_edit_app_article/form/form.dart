import '../../../../../common.dart';

class ArticleModelForm {
  ArticleModelForm({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  ArticleModelForm copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    Category? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ArticleModelForm(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static const String idControlName = 'id';
  static const String titleControlName = 'title';
  static const String contentControlName = 'content';
  static const String imageUrlControlName = 'imageUrl';
  static const String categoryControlName = 'category';
  static const String createdAtControlName = 'createdAt';
  static const String updatedAtControlName = 'updatedAt';

  final String? id;
  final String? title;
  final String? content;
  final String? imageUrl;
  final Category? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static FormGroup toFormGroup(ArticleModelForm model) {
    return FormGroup({
      idControlName: FormControl<String>(value: model.id),
      titleControlName: FormControl<String>(value: model.title),
      contentControlName: FormControl<String>(value: model.content),
      imageUrlControlName: FormControl<String>(value: model.imageUrl),
      categoryControlName: FormControl<Category>(value: model.category),
      createdAtControlName: FormControl<DateTime>(value: model.createdAt),
      updatedAtControlName: FormControl<DateTime>(value: model.updatedAt),
    });
  }

  static ArticleModelForm fromFormGroup(FormGroup formGroup) {
    return ArticleModelForm(
      id: formGroup.control(idControlName).value,
      title: formGroup.control(titleControlName).value,
      content: formGroup.control(contentControlName).value,
      imageUrl: formGroup.control(imageUrlControlName).value,
      category: formGroup.control(categoryControlName).value,
      createdAt: formGroup.control(createdAtControlName).value,
      updatedAt: formGroup.control(updatedAtControlName).value,
    );
  }
}

// import 'package:as_group/common.dart';
// import 'package:as_group/generated/protos/bdaya/as_group_finance/categories/v1/models.pb.dart';
// import 'package:as_group/generated/protos/bdaya/as_group_finance/v1/common.pbenum.dart';
// import 'package:reactive_forms_annotations/reactive_forms_annotations.dart'
//     hide Category;

// part 'form.gform.dart';

// @Rf()
// @RfGroup(validators: [
//   FormGroupLocalesValidator(
//       enableEnglishControlName: 'isEnglishEnabled', hasEnableEnglish: true)
// ])
// class ArticlesModel {
//   final List<LocaleEntry>? headline;
//   final Category? category;
//   final String? imageUrl;
//   final List<LocaleEntry>? article;
//   final List<LocaleEntry>? shortText;
//   final bool isEnglishEnabled;
//   final Status status;

//   ArticlesModel({
//     @RfArray<LocaleEntry>() this.headline,
//     @RfControl(validators: [RequiredValidator()]) this.category,
//     @RfControl(validators: [RequiredValidator()]) this.imageUrl,
//     @RfArray<LocaleEntry>() this.article,
//     @RfArray<LocaleEntry>() this.shortText,
//     @RfControl() this.isEnglishEnabled = false,
//     @RfControl(validators: [RequiredValidator()])
//     this.status = Status.STATUS_PUBLISHED,
//   });
// }
