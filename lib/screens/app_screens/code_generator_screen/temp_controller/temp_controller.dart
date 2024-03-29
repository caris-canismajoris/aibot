import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../../config.dart';

class TempCodeGeneratorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController codeController = TextEditingController();
  final FixedExtentScrollController? scrollController =
      FixedExtentScrollController();
  bool isCodeGenerate = false;
  bool isLoader = false;
  List codingLanguages = [];
  SpeechToText speech = SpeechToText();
  final FlutterTts? flutterTts = FlutterTts();
  final _isSpeech = false.obs;
  final isListening = false.obs;
  // BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;

  // AdManagerBannerAd? adManagerBannerAd;
  bool adManagerBannerAdIsLoaded = false;

  AnimationController? animationController;
  Animation? animation;

  int value = 0;
  String? selectItem;
  String? onSelect;
  String? response;
  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );

  //new_features
  String? markdownText;
  String? resultMessageAiCodes;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('json_class/languages.json');
    final data = await json.decode(response);
    codingLanguages = data;
    update();
  }

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
    readJson();
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

  final GeminiCodeCApi _geminiChatApi = GeminiCodeCApi();

  Future<void> onCodeGenerate() async {
    try {
      if (codeController.text.isNotEmpty) {
        int balance = appCtrl.envConfig["balance"];
        if (balance == 0) {
          appCtrl.balanceTopUpDialog();
        } else {
          addCtrl.onInterstitialAdShow();
          isLoader = true;

          // Tambahkan baris ini untuk menyimpan instance TempCodeGeneratorController
          TempCodeGeneratorController codeGeneratorCtrl =
              Get.find<TempCodeGeneratorController>();

          String customText =
              "Write a full code for ${codeController.text} in ${onSelect ?? "C#, and explain briefly, concisely and clearly!"} language";

          List<Content> value = (await _geminiChatApi.chatCompletionResponse(
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
              _geminiChatApi.onModelOutputChange
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
            codeGeneratorCtrl.setResultMessageAiCodes(
              resultMessageAi,
            ); // Tambahkan baris ini
            // print("hasilDariMarkdownText ==> ${markdownText}");

            if (value.isNotEmpty) {
              response = value.last.parts?.last.text ?? '';
              print("codeResponse ==> $response");
              isCodeGenerate = true;
            } else {
              snackBarMessengers(message: appFonts.somethingWentWrong.tr);
            }
          });
          isLoader = false;
          update();
        }
      } else {
        Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
      }
    } catch (error) {
      // Tambahkan penanganan kesalahan jika diperlukan
      print("Error: $error");
      isLoader = false;
      snackBarMessengers(message: appFonts.somethingWentWrong.tr);
      update();
    } finally {
      codeController.clear();
      update();
    }
  }

  Future<void> onContinueCodeGenerate() async {
    try {
      if (codeController.text.isNotEmpty) {
        int balance = appCtrl.envConfig["balance"];
        if (balance == 0) {
          appCtrl.balanceTopUpDialog();
        } else {
          addCtrl.onInterstitialAdShow();
          isLoader = true;

          // Tambahkan baris ini untuk menyimpan instance TempCodeGeneratorController
          TempCodeGeneratorController codeGeneratorCtrl =
              Get.find<TempCodeGeneratorController>();

          String customText =
              "continue or complete the code from the ${codeController.text} in ${onSelect ?? "C#"} language above!";

          List<Content> value = (await _geminiChatApi.chatCompletionResponse(
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
              _geminiChatApi.onModelOutputChange
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
            codeGeneratorCtrl.setResultMessageAiCodes(
                resultMessageAi); // Tambahkan baris ini
            // print("hasilDariMarkdownText ==> ${markdownText}");

            if (value.isNotEmpty) {
              response = value.last.parts?.last.text ?? '';
              print("codeResponse ==> $response");
              isCodeGenerate = true;
            } else {
              snackBarMessengers(message: appFonts.somethingWentWrong.tr);
            }
          });
          isLoader = false;
          update();
        }
      } else {
        Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
      }
    } catch (error) {
      // Tambahkan penanganan kesalahan jika diperlukan
      print("Error: $error");
      isLoader = false;
      snackBarMessengers(message: appFonts.somethingWentWrong.tr);
      update();
    } finally {
      codeController.clear();
      update();
    }
  }

  void setResultMessageAiCodes(String value) {
    resultMessageAiCodes = value;

    print("resultMessageAiCodes ==> $resultMessageAiCodes");
    update();
  }

  void resetCodeData() {
    resultMessageAiCodes = null;
    Get.toEnd(() => CodeGeneratorLayout());
    update();
    // dialogLayout.endDialog(
    //     title: appFonts.endCodeGenerator,
    //     subTitle: appFonts.areYouSureEndCodeGenerator,
    //     onTap: () {
    //       codeController.clear();
    //       resultMessageAiCodes = null;
    //       onSelect = 'C#';
    //       textToSpeechCtrl.onStopTTS();
    //       isCodeGenerate = false;
    //       Get.toEnd(() => CodeGeneratorLayout());
    //       update();
    //     });
  }

// GeminiChatApi geminiApiServices =
//         GeminiChatApi();

//     geminiApiServices.chatCompeletionResponse([
//       Content(
//         parts: [
//           Parts(
//             text: textInput.value,
//           ),
//         ],
//       )
//     ]);

//     List<Content> resultMessageAi = [];

//     StreamSubscription<List<Content>> processedResultAISubscription =
//         geminiApiServices.onModelOutputChange
//             .listen((List<Content> outputValue) {
//       print("Nilai Output dari controller_lain.dart: $outputValue");
//       resultMessageAi = outputValue;
//       print("resultMessageAi11 ==> $resultMessageAi");
//     });

//     processedResultAISubscription.onData((outputValue) {
//       // resultMessageAi = outputValue.parts?.lastOrNull?.text;

//       String resultMessageAi = outputValue
//           .map((content) => content.parts?.lastOrNull?.text ?? "")
//           .join(" ");

//       print("resultMessageAi1 ==> ${resultMessageAi}");

  // onCodeGenerate() {
  //   if (codeController.text.isNotEmpty) {
  //     int balance = appCtrl.envConfig["balance"];
  //     if (balance == 0) {
  //       appCtrl.balanceTopUpDialog();
  //     } else {
  //       addCtrl.onInterstitialAdShow();
  //       isLoader = true;
  //       ApiServices.chatCompeletionResponse(
  //               "Write a code for ${codeController.text} in ${onSelect ?? "C#"} language")
  //           .then((value) {
  //         if (value != "") {
  //           response = value;
  //           isCodeGenerate = true;
  //           isLoader = false;
  //           update();
  //         } else {
  //           isLoader = false;
  //           snackBarMessengers(message: appFonts.somethingWentWrong.tr);
  //           update();
  //         }
  //       });
  //       codeController.clear();
  //       update();
  //     }
  //   } else {
  //     Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
  //   }
  // }

  endCodeGeneratorDialog() {
    resultMessageAiCodes = null;
    dialogLayout.endDialog(
        title: appFonts.endCodeGenerator,
        subTitle: appFonts.areYouSureEndCodeGenerator,
        onTap: () {
          codeController.clear();
          resultMessageAiCodes = null;
          onSelect = 'C#';
          textToSpeechCtrl.onStopTTS();
          isCodeGenerate = false;
          Get.back();
          update();
        });
  }

  // from languages list
  onSelectLanguageSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: appCtrl.appTheme.white,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return GetBuilder<TempCodeGeneratorController>(
            builder: (codeGeneratorCtrl) {
          return LanguagePickerLayout(
            image: eSvgAssets.code,
            title: appFonts.selectCodeLanguage,
            list: codingLanguages,
            index: value,
            suggestionsCallbacks: (value) {
              return StateService.getSuggestions(
                  value, codingLanguages.cast<String>());
            },
            scrollController: codeGeneratorCtrl.scrollController,
            onSuggestionSelected: (i) {
              int index = codingLanguages.indexWhere((element) {
                return element == i;
              });
              codeGeneratorCtrl.scrollController!.jumpToItem(index);
              log("suggestion: $i");
              log("index: $index");
              update();
              codeGeneratorCtrl.update();
            },
            onSelectedItemChanged: (i) {
              value = i;
              selectItem = codingLanguages[i];
              log("SELECT ITEM: $selectItem");
              update();
              codeGeneratorCtrl.update();
            },
            selectOnTap: () {
              onSelect = selectItem;
              Get.back();
              codeGeneratorCtrl.update();
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

  //stop speech method
  speechStopMethod() async {
    _isSpeech.value = false;
    await flutterTts!.stop();
    update();
  }

  //speech to text
  void speechToText() async {
    speechStopMethod();
    codeController.text = '';

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
            codeController.text = val.recognizedWords.toString();
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
    codeController.clear();
    textToSpeechCtrl.onStopTTS();
    animationController!.dispose();
    super.dispose();
  }
}

// menyatukan kode
class GeminiCodeCApi {
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
