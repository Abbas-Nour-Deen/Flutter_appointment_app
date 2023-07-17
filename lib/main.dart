import 'package:appointment/services/notification_services.dart';
import 'package:appointment/services/theme_services.dart';
import 'package:appointment/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Screens/auth.dart';
import 'Screens/mainScreen.dart';
import 'Screens/splash.dart';
import 'db/db_helper.dart';
import 'firebase_options.dart';

var KColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
var KDarkColorScheme =
    ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.red);



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  await NotificationService.initializeNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: Themes.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.light,
      themeMode: ThemeService().theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            return mainScreen();
          }
          return const AuthScreen();
        }),
      ),
    );
  }
}
