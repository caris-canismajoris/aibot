import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../bot_api/api_services.dart';
import '../../config.dart';

class TranslateController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController transController = TextEditingController();
  TextEditingController transCompleteController = TextEditingController();
  bool isTranslated = false;
  final FlutterTts? flutterTts = FlutterTts();
  bool isLoader = false;
  dynamic selectItem;
  dynamic toSelectItem;
  dynamic onFromSelect;
  dynamic onToSelect;
  String? response = '';
  int value = 0;

  AnimationController? animationController;
  Animation? animation;

  SpeechToText speech = SpeechToText();
  // BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );
  // AdManagerBannerAd? adManagerBannerAd;
  bool adManagerBannerAdIsLoaded = false;

  final _isSpeech = false.obs;
  final isListening = false.obs;
  int toValue = 0;
  List<String> translateLanguagesList = [];
  final FixedExtentScrollController? fromScrollController =
      FixedExtentScrollController();
  final FixedExtentScrollController? toScrollController =
      FixedExtentScrollController();
  final ScrollController? thumbScrollController =
      ScrollController(initialScrollOffset: 50.0);

  //new_features
  String? markdownText;
  String? resultMessageAiTranslate;

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
    translateLanguagesList = appArray.translateLanguages;
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animationController!.repeat(reverse: true);
    animation = Tween(begin: 15.0, end: 24.0).animate(animationController!)
      ..addListener(() {
        update();
      });
    update();
    // TODO: implement onReady
    super.onReady();
  }

  //stop speech method
  speechStopMethod() async {
    _isSpeech.value = false;
    await flutterTts!.stop();
    update();
  }

  //speech to text
  void speechToText() async {
    speechStopMethod();
    transController.text = '';

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
            transController.text = val.recognizedWords.toString();
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

  @override
  void dispose() {
    transController.clear();
    textToSpeechCtrl.onStopTTS();
    animationController!.dispose();
    super.dispose();
  }

  void setResultMessageAiTranslate(String value) {
    resultMessageAiTranslate = value;

    print("resultMessageAiTranslate ==> $resultMessageAiTranslate");
    update();
  }

  onTranslate() async {
    if (transController.text.isNotEmpty) {
      int balance = appCtrl.envConfig["balance"];
      if (balance == 0) {
        appCtrl.balanceTopUpDialog();
      } else {
        addCtrl.onInterstitialAdShow();
        isLoader = true;

        GeminiTranslateApi geminiTranslateApiInstance = GeminiTranslateApi();

//new_features

        // Tambahkan baris ini untuk menyimpan instance TempCodeGeneratorController
        TranslateController translateGeneratorCtrl = Get.find<TranslateController>();

        String customText =
            "Translate ${transController.text} from ${onFromSelect ?? appFonts.english} to ${onToSelect ?? appFonts.hindi} language";

        List<Content> translateValue =
            (await geminiTranslateApiInstance.chatCompletionResponse(
          [
            Content(
              parts: [
                Parts(
                  text: customText,
                ),
              ],
            ),
          ],
          customText: customText,
        ))
                .cast<Content>();

        List<Content> resultMessageAi = [];

        StreamSubscription<List<Content>> processedResultsAISubscription =
            geminiTranslateApiInstance.onModelOutputChange
                .listen((List<Content> outputValue) {
          print("Nilai Outputs dari controller_lain.dart: $outputValue");
          resultMessageAi = outputValue;
          print("resultMessageAisTranslate ==> $resultMessageAi");
        });

        processedResultsAISubscription.onData((outputValue) {
          String resultMessageAi = outputValue
              .map((content) => content.parts?.lastOrNull?.text ?? "")
              .join(" ");

          print("resultMessageAiTranslate ==> ${resultMessageAi}");

          // Setel nilai markdownText dengan hasil AI dalam format Markdown
          // TranslateGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
          // print(
          //     "TranslateGeneratorCtrl.markdownText1 ==> ${markdownText}");

          // print("resultMessageAiTranslate ==> ${resultMessageAi}");

          // Setel nilai markdownText dengan hasil AI dalam format Markdown
          translateGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
          translateGeneratorCtrl
              .setResultMessageAiTranslate(resultMessageAi); // Tambahkan baris ini
          print("translateGeneratorCtrl ==> ${markdownText}");

          geminiTranslateApiInstance.chatCompletionResponse(
                  "Translate ${transController.text} from ${onFromSelect ?? appFonts.english} to ${onToSelect ?? appFonts.hindi} language" as List<Content>)
              .then((value) {
            if (value != "") {
              response = value as String?;
              update();
              isTranslated = true;
              isLoader = false;
              update();
            } else {
              isLoader = false;
              snackBarMessengers(message: appFonts.somethingWentWrong.tr);
              update();
            }
          });
          update();
        });
      }
    } else {
      Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
    }
  }

  endTranslationDialog() {
    dialogLayout.endDialog(
        title: appFonts.endTranslation,
        subTitle: appFonts.areYouSure,
        onTap: () {
          transController.clear();
          textToSpeechCtrl.onStopTTS();
          isTranslated = false;
          Get.back();
          update();
        });
  }

  // from languages list
  onFromLanguageSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: appCtrl.appTheme.white,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return GetBuilder<TranslateController>(builder: (translateCtrl) {
          return LanguagePickerLayout(
            list: translateLanguagesList,
            title: appFonts.selectLanguage,
            index: value,
            scrollController: translateCtrl.fromScrollController,
            thumbScrollController: thumbScrollController,
            suggestionsCallbacks: (value) {
              return StateService.getSuggestions(value, translateLanguagesList);
            },
            onSuggestionSelected: (i) {
              int index =
                  translateCtrl.translateLanguagesList.indexWhere((element) {
                return element == i;
              });
              translateCtrl.fromScrollController!.jumpToItem(index);
              log("suggestion: $i");
              log("index: $index");
              update();
              translateCtrl.update();
            },
            onSelectedItemChanged: (i) {
              value = i;
              selectItem = translateLanguagesList[i];
              log("SELECT ITEM: $selectItem");
              update();
              translateCtrl.update();
            },
            selectOnTap: () {
              onFromSelect = selectItem;
              Get.back();
              translateCtrl.update();
            },
          );
        });
      }),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppRadius.r10),
              topLeft: Radius.circular(AppRadius.r10))),
    );
  }

  // to language list
  onToLanguageSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: appCtrl.appTheme.white,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return GetBuilder<TranslateController>(builder: (translateCtrl) {
          return LanguagePickerLayout(
            title: appFonts.selectLanguage,
            list: translateLanguagesList,
            index: toValue,
            scrollController: translateCtrl.toScrollController,
            suggestionsCallbacks: (value) {
              return StateService.getSuggestions(value, translateLanguagesList);
            },
            onSelectedItemChanged: (i) {
              toValue = i;
              toSelectItem = translateLanguagesList[i];
              log("SELECT ITEM: $toSelectItem");
              update();
              translateCtrl.update();
            },
            onSuggestionSelected: (i) {
              int index =
                  translateCtrl.translateLanguagesList.indexWhere((element) {
                return element == i;
              });
              translateCtrl.toScrollController!.jumpToItem(index);
              log("suggestion: $i");
              log("index: $index");
              update();
              translateCtrl.update();
            },
            selectOnTap: () {
              onToSelect = toSelectItem;
              Get.back();
              translateCtrl.update();
            },
          );
        });
      }),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppRadius.r10),
            topLeft: Radius.circular(AppRadius.r10)),
      ),
    );
  }

  @override
  void onClose() {
    animationController!.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}

class GeminiTranslateApi {
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
