// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'common.dart' as _i424;
import 'src/pages/articles/add_or_edit_app_article/controller.dart' as _i140;
import 'src/pages/articles/controller.dart' as _i928;
import 'src/pages/categories/controller.dart' as _i51;
import 'src/pages/files/controller.dart' as _i538;
import 'src/pages/home/controller.dart' as _i635;
import 'src/pages/services/add_or_edit_app_service/controller.dart' as _i882;
import 'src/pages/services/controller.dart' as _i697;
import 'src/services/about/fake.dart' as _i479;
import 'src/services/about/real.dart' as _i334;
import 'src/services/articles/fake.dart' as _i451;
import 'src/services/articles/real.dart' as _i810;
import 'src/services/auth/fake.dart' as _i268;
import 'src/services/auth/real.dart' as _i505;
import 'src/services/categories/base.dart' as _i936;
import 'src/services/categories/fake.dart' as _i838;
import 'src/services/categories/real.dart' as _i22;
import 'src/services/files/fake.dart' as _i95;
import 'src/services/files/real.dart' as _i269;
import 'src/services/services/fake.dart' as _i949;
import 'src/services/services/real.dart' as _i288;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i424.FileService>(
      () => _i95.FakeFileService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i424.AboutUsService>(
      () => _i479.FakeAboutUsService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i424.AuthService>(
      () => _i268.FakeAuthService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i424.ArticleService>(
      () => _i451.FakeArticleService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i936.CategoriesService>(
      () => _i838.FakeCategoriesService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i424.ServiceService>(
      () => _i949.FakeServiceService(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i424.ServiceService>(
      () => _i288.RealServiceService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i936.CategoriesService>(
      () => _i22.RealCategoriesService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i424.AboutUsService>(
      () => _i334.RealAboutUsService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i424.FileService>(
      () => _i269.RealFileService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i424.AuthService>(
      () => _i505.RealAuthService(),
      registerFor: {_prod},
    );
    gh.factoryParam<
      _i882.AddOrEditAppServiceDialogController,
      _i882.AddOrEditAppServiceParams,
      dynamic
    >(
      (parameters, _) => _i882.AddOrEditAppServiceDialogController(
        gh<_i424.FileService>(),
        gh<_i424.ServiceService>(),
        parameters,
      ),
    );
    gh.lazySingleton<_i51.CategoriesController>(
      () => _i51.CategoriesController(gh<_i936.CategoriesService>()),
    );
    gh.lazySingleton<_i424.ArticleService>(
      () => _i810.RealArticleService(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i538.FilesController>(
      () => _i538.FilesController(gh<_i424.FileService>()),
    );
    gh.lazySingleton<_i697.ServicesController>(
      () => _i697.ServicesController(gh<_i424.ServiceService>()),
    );
    gh.lazySingleton<_i928.ArticlesController>(
      () => _i928.ArticlesController(gh<_i424.ArticleService>()),
    );
    gh.lazySingleton<_i635.HomeController>(
      () => _i635.HomeController(
        gh<_i424.ArticleService>(),
        gh<_i424.ServiceService>(),
        gh<_i424.FileService>(),
        gh<_i424.AboutUsService>(),
      ),
    );
    gh.factoryParam<
      _i140.AddOrEditArticleDialogController,
      _i140.AddOrEditArticleDialogParams,
      dynamic
    >(
      (parameters, _) => _i140.AddOrEditArticleDialogController(
        parameters,
        gh<_i424.FileService>(),
        gh<_i424.ArticleService>(),
        gh<_i936.CategoriesService>(),
      ),
    );
    return this;
  }
}
