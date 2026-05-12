import 'common.dart';
import 'get_it_config.config.dart';

// const realEnv = Environment('real');
// const testEnv = Environment('dev');
const currentEnvironment = String.fromEnvironment('env');

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init(environment: currentEnvironment);
