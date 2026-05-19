import 'common.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://uvjnmrloxlsdmpvwhgqn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV2am5tcmxveGxzZG1wdndoZ3FuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxMzkyMTMsImV4cCI6MjA5NDcxNTIxM30.hobTpXuE9iC-FEbBcvzI_ThxLCGcOCQd2dFcPAy29kw',
  );

  setPathUrlStrategy();
  Logger.root.level = Level.ALL; // for full logging
  Logger.root.onRecord.listen((log) {
    debugPrint('${log.level.name}: ${log.time}: ${log.message}');
  });

  runApp(ProviderScope(child: const MyApp()));
}
