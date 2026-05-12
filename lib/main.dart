import 'common.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  getIt.allowReassignment = true;
  configureDependencies();
  setPathUrlStrategy();
  Logger.root.level = Level.ALL; // for full logging
  Logger.root.onRecord.listen((log) {
    debugPrint('${log.level.name}: ${log.time}: ${log.message}');
  });
  runApp(ProviderScope(child: const MyApp()));
}
