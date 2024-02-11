import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../../config.dart';
import 'temp_essay_screen.dart';

class EssayWriterControllerTemp extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController essayController = TextEditingController();
  // TextEditingController essayGeneratedController = TextEditingController();
  List essayTypeLists = [];
  int selectedIndex = 0;
  bool isEssayGenerated = false;
  bool isLoader = false;
  String? response;
  AnimationController? animationController;
  Animation? animation;
  SpeechToText speech = SpeechToText();
  final _isSpeech = false.obs;
  final FlutterTts? flutterTts = FlutterTts();
  final isListening = false.obs;
  // BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );

  //new_features
  String? markdownText;
  String? resultMessageAiCodes;

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // Unique ID on Android
    }
  }

  _showBannerAd() {
    log("SHOW BANNER");
    currentAd = FacebookBannerAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: Platform.isAndroid
          ? appCtrl.firebaseConfigModel!.facebookAddAndroidId!
          : appCtrl.firebaseConfigModel!.facebookAddIOSId!,
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        log("Banner Ad: $result -->  $value");
      },
    );
    update();
    log("_currentAd : $currentAd");
  }

  // buildBanner() async {
  //   bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: Platform.isAndroid
  //           ? appCtrl.firebaseConfigModel!.bannerAddId!
  //           : appCtrl.firebaseConfigModel!.bannerIOSId!,
  //       listener: BannerAdListener(
  //         onAdLoaded: (Ad ad) {
  //           log('$BannerAd loaded.');
  //           bannerAdIsLoaded = true;
  //           update();
  //         },
  //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //           log('$BannerAd failedToLoad: $error');
  //           ad.dispose();
  //         },
  //         onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
  //         onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
  //       ),
  //       request: const AdRequest())
  //     ..load();
  //   log("Home Banner AGAIn: $bannerAd");
  // }

  //stop speech method
  speechStopMethod() async {
    _isSpeech.value = false;
    await flutterTts!.stop();
    update();
  }

  //speech to text
  void speechToText() async {
    speechStopMethod();
    essayController.text = '';

    log("ISLISTEN : ${isListening.value}");
    if (isListening.value == false) {
      bool available = await speech.initialize(
        onStatus: (val) {
          debugPrint('*** onStatus: $val');
          log("loo : ${val == "done"}");
          if (val == "done" || val == "notListening") {
            isListening.value = false;
            update();
          }
          Get.forceAppUpdate();
        },
        onError: (val) {
          debugPrint('### onError: $val');
        },
      );
      log("available ; $available");
      if (available) {
        isListening.value = true;

        speech.listen(
          localeId: appCtrl.languageVal,
          onResult: (val) {
            log("VAL : $val");
            essayController.text = val.recognizedWords.toString();
            update();
          },
          cancelOnError: true,
        );

        update();
      } else {
        log("NO");
      }
    } else {
      isListening.value = false;
      speechStopMethod();
      update();
    }
  }

  ///new
  final GeminiEssayApi _geminiEssayApi = GeminiEssayApi();

  Future<void> onEssayGenerated() async {
    try {
      int balance = appCtrl.envConfig["balance"];
      if (balance == 0) {
        appCtrl.balanceTopUpDialog();
      } else {
        addCtrl.onInterstitialAdShow();
        isLoader = true;

        // Tambahkan baris ini untuk menyimpan instance PasswordControllerTemp
        EssayWriterControllerTemp codeGeneratorCtrl =
            Get.find<EssayWriterControllerTemp>();

        String customText =
            "Write a perfect essay with a title about ${essayController.text} in tone of ${selectedIndex == 0 ? "Informative" : selectedIndex == 1 ? "Persuade" : "Analyze"} ";
        // "Write a essay on ${essayController.text} in tone of ${selectedIndex == 0 ? "Informative" : selectedIndex == 1 ? "Persuade" : "Analyze"} ";

        List<Content> valuePassGen =
            (await _geminiEssayApi.chatCompletionResponse(
          [
            Content(
              parts: [
                Parts(
                  text: customText,
                ),
              ],
            ),
          ],
          customText: customText, // Gunakan customText
        ))
                .cast<Content>();

        List<Content> resultMessageAi = [];

        StreamSubscription<List<Content>> processedResultsAISubscription =
            _geminiEssayApi.onModelOutputChange
                .listen((List<Content> outputValue) {
          print("Nilai Outputs dari controller_lain.dart: $outputValue");
          resultMessageAi = outputValue;
          print("resultMessageAis ==> $resultMessageAi");
        });

        processedResultsAISubscription.onData((outputValue) {
          String resultMessageAi = outputValue
              .map((content) => content.parts?.lastOrNull?.text ?? "")
              .join(" ");

          print("resultMessageAiCode ==> ${resultMessageAi}");

          // Setel nilai markdownText dengan hasil AI dalam format Markdown
          // codeGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
          // print(
          //     "codeGeneratorCtrl.markdownText1 ==> ${markdownText}");

          print("resultMessageAiCode ==> ${resultMessageAi}");

          // Setel nilai markdownText dengan hasil AI dalam format Markdown
          codeGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
          codeGeneratorCtrl
              .setResultMessageAiCodes(resultMessageAi); // Tambahkan baris ini
          // print("hasilDariMarkdownText ==> ${markdownText}");

          if (valuePassGen.isNotEmpty) {
            response = valuePassGen.last.parts?.last.text ?? '';
            print("codeResponse ==> $response");
            //       response = value;
            isEssayGenerated = true;
            // isLoader = false;
            update();
          } else {
            isLoader = false;
            snackBarMessengers(message: appFonts.somethingWentWrong.tr);
            update();
          }
        });
        isLoader = false;
        update();
      }
    } catch (error) {
      // Tambahkan penanganan kesalahan jika diperlukan
      print("Error: $error");
      isLoader = false;
      snackBarMessengers(message: appFonts.somethingWentWrong.tr);
      update();
    } finally {
      essayController.clear();
      selectedIndex = 0;
      update();
    }
  }

  void setResultMessageAiCodes(String value) {
    resultMessageAiCodes = value;

    print("resultMessageAiCodes ==> $resultMessageAiCodes");
    update();
  }

  void resetCodeData() {
    EssayWriterControllerTemp codeGeneratorCtrl =
        Get.find<EssayWriterControllerTemp>();
    resultMessageAiCodes = null;
    setResultMessageAiCodes('');
    codeGeneratorCtrl.resultMessageAiCodes = null;
    markdownText = null;
    response = null;
    markdownText = "";
    response = "";
    resultMessageAiCodes;
    essayController.text = "";
    print('resultMessageAiCodes1 ==> $resultMessageAiCodes');
    print('markdownText1 ==> $markdownText');
    print('response1 ==> $response');
    print('markdownText2 ==> $markdownText');
    print('response2 ==> $response');
    print('essayController.text1 ==> ${essayController.text}');

    Get.toEnd(() => TempEssayWriterScreen());
    update();
  }
  
  ///////////////////
  ///
  ///
  //
  ///
  /////////////////////////////

  ///features

  // onEssayGenerated() {
  //   if (essayController.text.isNotEmpty) {
  //     int balance = appCtrl.envConfig["balance"];
  //     if (balance == 0) {
  //       appCtrl.balanceTopUpDialog();
  //     } else {
  //       addCtrl.onInterstitialAdShow();
  //       isLoader = true;
  //       ApiServices.chatCompeletionResponse(
  //               "Write a essay on ${essayController.text} in tone of ${selectedIndex == 0 ? "Informative" : selectedIndex == 1 ? "Persuade" : "Analyze"} ")
  //           .then((value) {
  //         if (value != "") {
  //           response = value;
  //           isEssayGenerated = true;
  //           isLoader = false;
  //           update();
  //         } else {
  //           isLoader = false;
  //           snackBarMessengers(message: appFonts.somethingWentWrong.tr);
  //           update();
  //         }
  //       });
  //       essayController.clear();
  //       selectedIndex = 0;
  //       update();
  //     }
  //   } else {
  //     Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
  //   }
  // }

  onEssayTypeChange(index) {
    selectedIndex = index;
    update();
  }

  endEssayWriterDialog() {
    Get.generalDialog(
        pageBuilder: (context, anim1, anim2) {
          return AdviserDialog(
              title: appFonts.endEssayWriting,
              subTitle: appFonts.areYouEndEssayWriting,
              endOnTap: () {
                essayController.clear();
                selectedIndex = 0;
                textToSpeechCtrl.onStopTTS();
                isEssayGenerated = false;
                Get.back();
                update();
              });
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(anim1),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300));
  }

  @override
  void onReady() {
    appCtrl.firebaseConfigModel = FirebaseConfigModel.fromJson(
        appCtrl.storage.read(session.firebaseConfig));
    log("BANNER: ${appCtrl.firebaseConfigModel!}");
    // if (bannerAd == null) {
    //   bannerAd = BannerAd(
    //       size: AdSize.banner,
    //       adUnitId: Platform.isAndroid
    //           ? appCtrl.firebaseConfigModel!.bannerAddId!
    //           : appCtrl.firebaseConfigModel!.bannerIOSId!,
    //       listener: BannerAdListener(
    //         onAdLoaded: (Ad ad) {
    //           log('$BannerAd loaded.');
    //           bannerAdIsLoaded = true;
    //           update();
    //         },
    //         onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //           log('$BannerAd failedToLoad: $error');
    //           ad.dispose();
    //         },
    //         onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
    //         onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
    //       ),
    //       request: const AdRequest())
    //     ..load();
    //   log("Home Banner : $bannerAd");
    // } else {
    //   bannerAd!.dispose();
    //   buildBanner();
    // }
    _getId().then((id) {
      String? deviceId = id;
      FacebookAudienceNetwork.init(
        testingId: deviceId,
        iOSAdvertiserTrackingEnabled: true,
      );
    });
    _showBannerAd();
    addCtrl.onInterstitialAdShow();
    essayTypeLists = appArray.essayTypeList;
    update();
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void dispose() {
    essayController.clear();
    selectedIndex = 0;
    textToSpeechCtrl.onStopTTS();
    // TODO: implement dispose
    super.dispose();
  }
}

// menyatukan kode
class GeminiEssayApi {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Map<String, String>>> chatCompletionResponse(
    List<Content> chats, {
    List<Map<String, String>>? conversationHistory,
    String? customText, // Tambahkan parameter opsional untuk customText
  }) async {
    bool isLocalChatApi = appCtrl.storage.read(session.isGeminiKey) ?? false;

    if (isLocalChatApi == false) {
      final firebaseCtrl = Get.isRegistered<SubscriptionFirebaseController>()
          ? Get.find<SubscriptionFirebaseController>()
          : Get.put(SubscriptionFirebaseController());
      firebaseCtrl.removeBalance();
    }

    List<Map<String, String>> currentConversationHistory =
        conversationHistory ?? [];

    await gemini.streamChat(chats).forEach((value) {
      if (chats.isNotEmpty && chats.last.role == value.content?.role) {
        chats.last.parts!.last.text =
            '${chats.last.parts!.last.text}${value.output}';
      } else {
        chats.add(
          Content(
            role: 'model',
            parts: [
              Parts(text: value.output),
            ],
          ),
        );
      }

      if (value.content?.role == 'model') {
        modelOutput.add(Content(
          role: 'model',
          parts: [Parts(text: value.output)],
        ));

        _modelOutputController.add(modelOutput);
      }

      currentConversationHistory.add({
        "role": value.content?.role ?? "",
        "content": value.output ?? "",
      });
    });

    return currentConversationHistory;
  }
}
