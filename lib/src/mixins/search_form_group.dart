import '../../common.dart';

mixin SearchFormGroup {
  late final FormGroup searchFG = FormGroup({
    kSearchFCN: FormControl<String>(),
  });
}
