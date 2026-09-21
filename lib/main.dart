import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/user_store.dart';
import 'screens/splash_screen.dart';
import 'settings/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // The on-device user (created once, on first launch) and saved settings
  // back everything downstream — Dashboard, Profile, the settings toggles —
  // so both are ready before the widget tree ever builds a frame.
  await Future.wait([UserStore.load(), AppSettings.load()]);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sukatech',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
