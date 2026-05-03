import 'package:custom_dashboard/common.dart';
import 'package:custom_dashboard/src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.allowReassignment = true;
  configureDependencies();
  Logger.level = Level.all;
  Logger.addLogListener((log) {
    debugPrint('${log.level.name}: ${log.time}: ${log.message}');
  });
  runApp(const MyApp());
}
