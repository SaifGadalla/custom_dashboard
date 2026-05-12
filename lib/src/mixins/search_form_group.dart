import '../../common.dart';

mixin SearchFormGroup {
  FormGroup get searchFG => FormGroup({kSearchFCN: FormControl<String>()});
}
