import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/services/register_services.dart';
import 'package:thinking_capp/views/startup.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  registerServices();
  runApp(const ThinkingCApp());
}

class ThinkingCApp extends StatelessWidget {
  const ThinkingCApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: GetMaterialApp(
        title: 'Thinking CApp',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          fontFamily: 'DM Sans',
          scaffoldBackgroundColor: Palette.black,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
          ),
          colorScheme: ColorScheme.dark(
            primary: Palette.primary,
            secondary: Palette.secondary,
            onPrimary: Colors.black,
            onSecondary: Colors.black,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),
        defaultTransition: Transition.rightToLeft,
        home: const StartupView(),
      ),
    );
  }
}
