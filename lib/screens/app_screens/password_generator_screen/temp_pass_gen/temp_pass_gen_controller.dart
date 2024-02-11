import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../../config.dart';

class PasswordControllerTemp extends GetxController {
  TextEditingController passwordControllerTemp = TextEditingController();

  double value = 11;
  double strengthValue = 0;
  List passwordTypeLists = [];
  List passwordStrengthLists = [];
  int selectedIndex = 0;
  bool isPasswordGenerated = false;
  bool isLoader = false;
  String? response;
  // BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );

  //new_features
  String? markdownText;
  String? resultMessageAiCodes;

  onChangePasswordType(index) {
    selectedIndex = index;
    update();
  }

  final GeminiPassGenApi _geminiPassGenApi = GeminiPassGenApi();

  Future<void> onPasswordGenerate() async {
    try {
        int balance = appCtrl.envConfig["balance"];
        if (balance == 0) {
          appCtrl.balanceTopUpDialog();
        } else {
          addCtrl.onInterstitialAdShow();
          isLoader = true;

          // Tambahkan baris ini untuk menyimpan instance PasswordControllerTemp
          PasswordControllerTemp codeGeneratorCtrl =
              Get.find<PasswordControllerTemp>();

          String customText =
              "Create password which length of $value and password type of ${passwordTypeLists[selectedIndex]} and password strength is ${passwordStrengthLists[strengthValue.toInt()]} ";

          List<Content> valuePassGen =
              (await _geminiPassGenApi.chatCompletionResponse(
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
          )).cast<Content>();

          List<Content> resultMessageAi = [];

          StreamSubscription<List<Content>> processedResultsAISubscription =
              _geminiPassGenApi.onModelOutputChange
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

            if (valuePassGen.isNotEmpty) {
              response = valuePassGen.last.parts?.last.text ?? '';
              print("codeResponse ==> $response");
              //       response = value;
              isPasswordGenerated = true;
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
      passwordControllerTemp.clear();
      update();
    }
  }

  void setResultMessageAiCodes(String value) {
    resultMessageAiCodes = value;

    print("resultMessageAiCodes ==> $resultMessageAiCodes");
    update();
  }

  // onPasswordGenerate() {
  //   int balance = appCtrl.envConfig["balance"];
  //   if (balance == 0) {
  //     appCtrl.balanceTopUpDialog();
  //   } else {
  //     addCtrl.onInterstitialAdShow();
  //     isLoader = true;

  //     /// ini kode kode baru
  //     ///

  //     final GeminiPassGenApi _geminiPassGenApi = GeminiPassGenApi();

  //     Future<void> onCodeGenerate() async {
  //       try {
  //         if (passwordControllerTemp.text.isNotEmpty) {
  //           int balance = appCtrl.envConfig["balance"];
  //           if (balance == 0) {
  //             appCtrl.balanceTopUpDialog();
  //           } else {
  //             addCtrl.onInterstitialAdShow();
  //             isLoader = true;

  //             // Tambahkan baris ini untuk menyimpan instance PasswordControllerTemp
  //             PasswordControllerTemp codeGeneratorCtrl =
  //                 Get.find<PasswordControllerTemp>();

  //             String customText =
  //                 "Create password which length of $value and password type of ${passwordTypeLists[selectedIndex]} and password strength is ${passwordStrengthLists[strengthValue.toInt()]} ";

  //             List<Content> valuePassGen =
  //                 (await _geminiPassGenApi.chatCompletionResponse(
  //               [
  //                 Content(
  //                   parts: [
  //                     Parts(
  //                       text: customText,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //               customText: customText, // Gunakan customText
  //             ))
  //                     .cast<Content>();

  //             List<Content> resultMessageAi = [];

  //             StreamSubscription<List<Content>> processedResultsAISubscription =
  //                 _geminiPassGenApi.onModelOutputChange
  //                     .listen((List<Content> outputValue) {
  //               print("Nilai Outputs dari controller_lain.dart: $outputValue");
  //               resultMessageAi = outputValue;
  //               print("resultMessageAis ==> $resultMessageAi");
  //             });

  //             processedResultsAISubscription.onData((outputValue) {
  //               String resultMessageAi = outputValue
  //                   .map((content) => content.parts?.lastOrNull?.text ?? "")
  //                   .join(" ");

  //               print("resultMessageAiCode ==> ${resultMessageAi}");

  //               // Setel nilai markdownText dengan hasil AI dalam format Markdown
  //               // codeGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
  //               // print(
  //               //     "codeGeneratorCtrl.markdownText1 ==> ${markdownText}");

  //               print("resultMessageAiCode ==> ${resultMessageAi}");

  //               // Setel nilai markdownText dengan hasil AI dalam format Markdown
  //               codeGeneratorCtrl.markdownText =
  //                   "## Hasil AI:\n\n$resultMessageAi";
  //               codeGeneratorCtrl.setResultMessageAiCodes(
  //                   resultMessageAi); // Tambahkan baris ini
  //               // print("hasilDariMarkdownText ==> ${markdownText}");

  //               if (valuePassGen.isNotEmpty) {
  //                 response = valuePassGen.last.parts?.last.text ?? '';
  //                 print("codeResponse ==> $response");
  //                 //       response = value;
  //                 isPasswordGenerated = true;
  //                 isLoader = false;
  //                 update();
  //               } else {
  //                 isLoader = false;
  //                 snackBarMessengers(message: appFonts.somethingWentWrong.tr);
  //                 update();
  //               }
  //             });
  //             isLoader = false;
  //             update();
  //           }
  //         } else {
  //           Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
  //         }
  //       } catch (error) {
  //         // Tambahkan penanganan kesalahan jika diperlukan
  //         print("Error: $error");
  //         isLoader = false;
  //         snackBarMessengers(message: appFonts.somethingWentWrong.tr);
  //         update();
  //       } finally {
  //         passwordControllerTemp.clear();
  //         update();
  //       }
  //     }

  //     void setResultMessageAiCodes(String value) {
  //       resultMessageAiCodes = value;

  //       print("resultMessageAiCodes ==> $resultMessageAiCodes");
  //       update();
  //     }

  //     ///
  //     /// ini kode kode baru

  //     // ApiServices.chatCompeletionResponse(
  //     //         "Create password which length of $value and password type of ${passwordTypeLists[selectedIndex]} and password strength is ${passwordStrengthLists[strengthValue.toInt()]} ")
  //     //     .then(
  //     //   (value) {
  //     //     if (value != "") {
  //     //       response = value;
  //     //       isPasswordGenerated = true;
  //     //       isLoader = false;
  //     //       update();
  //     //     } else {
  //     //       isLoader = false;
  //     //       snackBarMessengers(message: appFonts.somethingWentWrong.tr);
  //     //       update();
  //     //     }
  //     //   },
  //     // );
  //     update();
  //   }
  // }

  endPasswordGeneratorDialog() {
    Get.generalDialog(
        pageBuilder: (context, anim1, anim2) {
          return AdviserDialog(
              title: appFonts.endPasswordGenerator,
              subTitle: appFonts.areYouSureEndPasswordGenerator,
              endOnTap: () {
                value = 11;
                strengthValue = 0;
                selectedIndex = 0;
                textToSpeechCtrl.onStopTTS();
                passwordControllerTemp.clear();
                isPasswordGenerated = false;
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
    passwordStrengthLists = appArray.passwordStrengthList;
    passwordTypeLists = appArray.passwordTypeList;
    update();
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void dispose() {
    value = 11;
    strengthValue = 0;
    selectedIndex = 0;
    passwordControllerTemp.clear();
    // TODO: implement dispose
    super.dispose();
  }
}

// menyatukan kode
class GeminiPassGenApi {
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
