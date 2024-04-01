import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/services.dart';

import 'package:aibot/controllers/common_controllers/ad_controller.dart';

import 'package:aibot/controllers/common_controllers/text_to_speech_controller.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;

import 'bot_api/api_services.dart';
import 'common/languages/index.dart';

import 'config.dart';
import 'firebase_options.dart';

void main() async {
  await GetStorage.init();
  Gemini.init(
    apiKey:
        "AIzaSyDRTztoJNhhwfso60gm_i80Dah_dOqdOfI", //.ApiServices.getApiKey(),
    enableDebugging: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await Firebase.initializeApp(
  //   // name: 'aibot-admin',
  //   options: const FirebaseOptions(
  //       apiKey: "AIzaSyBaaqWpW6jRQw3rC03ZWlvnoptmVkXf96c",
  //       authDomain: "aibot-admin.firebaseapp.com",
  //       databaseURL:
  //           "https://aibot-admin-default-rtdb.asia-southeast1.firebasedatabase.app",
  //       projectId: "aibot-admin",
  //       storageBucket: "aibot-admin.appspot.com",
  //       messagingSenderId: "219810447668",
  //       appId: "1:219810447668:web:ffcb6ecefa76a1a8e62561",
  //       measurementId: "G-143GP4B12Q"),
  // );

  // MobileAds.instance.initialize();

  // Konfigurasi ID perangkat uji
  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //     testDeviceIds: <String>["DF75BCE5E986C6A29CC4BBB17F6506FA"],
  //   ),
  // );

  Get.put(AdController());
  Get.put(TextToSpeechController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//turnoff features
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> statusSnapshot) {
          log("STATUS : ${statusSnapshot.data}");

          return GetMaterialApp(
              themeMode: ThemeService().theme,
              theme: AppTheme.fromType(ThemeType.light).themeData,
              darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
              locale: const Locale('en', 'US'),
              translations: Language(),
              fallbackLocale: const Locale('en', 'US'),
              home: SplashScreen(),
              title: 'aibot',//appFonts.proBot.tr,
              getPages: appRoute.getPages,
              debugShowCheckedModeBanner: false);
        });
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
