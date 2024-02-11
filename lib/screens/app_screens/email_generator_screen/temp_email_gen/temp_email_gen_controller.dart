import 'dart:async';

import 'package:aibot/config.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'temp_email_gen.dart';

class TempEmailGeneratorController extends GetxController {
  TextEditingController topicController = TextEditingController();
  TextEditingController writeFromController = TextEditingController();
  TextEditingController writeToController = TextEditingController();
  TextEditingController generatedMailController = TextEditingController();
  List toneLists = [];
  List mailLengthLists = [];
  int selectIndex = 0;
  double value = 0;
  bool isMailGenerated = false;
  bool isLoader = false;
  String? response = "";

  //new_features
  String? markdownText;
  String? resultMessageAiemail;
  final GeminiEmailApi _geminiChatApi = GeminiEmailApi();

  void setResultMessageAiCodes(String value) {
    resultMessageAiemail = value;

    print("resultMessageAiemail ==> $resultMessageAiemail");
    update();
  }

  void resetEmailData() {
    resultMessageAiemail = null;
    topicController.text = "";
    writeFromController.text = "";
    writeToController.text = "";
    generatedMailController.text = "";
    markdownText = null;
    topicController.clear();
    writeFromController.clear();
    writeToController.clear();
    generatedMailController.clear();
    // textToSpeechCtrl.onStopTTS();
    isMailGenerated = false;
    update();
  }

  Future<void> onGenerateMail() async {
    try {
      if (topicController.text.isNotEmpty ||
          writeFromController.text.isNotEmpty ||
          writeToController.text.isNotEmpty) {
        int balance = appCtrl.envConfig["balance"];
        if (balance == 0) {
          appCtrl.balanceTopUpDialog();
        } else {
          addCtrl.onInterstitialAdShow();
          isLoader = true;

// ===============

          // Tambahkan baris ini untuk menyimpan instance TempEmailGeneratorController
          TempEmailGeneratorController emailGeneratorCtrl =
              Get.find<TempEmailGeneratorController>();

          String customText =
              "Forget and delete all previous conversations, and this email has nothing to do with the previous one. Write a new '${mailLengthLists[selectIndex]}' mail to '${writeToController.text}' from '${writeFromController.text}' for topic '${topicController.text}' in '${toneLists[selectIndex]}' tone.";

          List<Content> emailValue =
              (await _geminiChatApi.chatCompletionResponse(
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

          List<Content> resultemailAi = [];

          StreamSubscription<List<Content>> processedResultsAISubscription =
              _geminiChatApi.onModelOutputChange
                  .listen((List<Content> outputValue) {
            print("Nilai Outputs dari controller_lain.dart: $outputValue");
            resultemailAi = outputValue;
            print("resultMessageAis ==> $resultemailAi");
          });
// ===============

          processedResultsAISubscription.onData((outputValue) {
            String resultMessageAi = outputValue
                .map((content) => content.parts?.lastOrNull?.text ?? "")
                .join(" ");

            print("resultMessageAiemail ==> ${resultMessageAi}");

            // Setel nilai markdownText dengan hasil AI dalam format Markdown
            // codeGeneratorCtrl.markdownText = "## Hasil AI:\n\n$resultMessageAi";
            // print(
            //     "codeGeneratorCtrl.markdownText1 ==> ${markdownText}");

            // Setel nilai markdownText dengan hasil AI dalam format Markdown
            emailGeneratorCtrl.markdownText =
                "## Hasil AI:\n\n$resultMessageAi";
            emailGeneratorCtrl.setResultMessageAiCodes(
              resultMessageAi,
            ); // Tambahkan baris ini
            // print("hasilDariMarkdownText ==> ${markdownText}");

            // ApiServices.chatCompeletionResponse(
            //         "Write a ${mailLengthLists[selectIndex]} mail to ${writeToController.text} from ${writeFromController.text} for ${topicController.text} in ${toneLists[selectIndex]} tone")
            //     .then((value) {

            if (emailValue != "") {
              response = emailValue as String?;
              print("emailValue2 ==> ${emailValue}");
              update();
              isMailGenerated = true;
              isLoader = false;
              update();
            } else {
              isLoader = false;
              snackBarMessengers(message: appFonts.somethingWentWrong.tr);
              update();
            }
            // }
          });
          topicController.clear();
          writeFromController.clear();
          writeToController.clear();
          generatedMailController.clear();
          update();
        }
      } else {
        Get.snackbar(appFonts.attention.tr, appFonts.enterTextBoxValue.tr);
      }
    } catch (e) {
      print(e);
    }
  }

  onToneChange(index) {
    selectIndex = index;
    update();
  }

  endEmailGeneratorDialog() {
    dialogLayout.endDialog(
        title: appFonts.endEmailWriter,
        subTitle: appFonts.areYouSureEndEmail,
        onTap: () {
          topicController.clear();
          writeFromController.clear();
          writeToController.clear();
          generatedMailController.clear();
          textToSpeechCtrl.onStopTTS();
          isMailGenerated = false;
          Get.back();
          update();
        });
  }

  @override
  void onReady() {
    addCtrl.onInterstitialAdShow();
    toneLists = appArray.toneList;
    mailLengthLists = appArray.mailLengthList;
    update();
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void dispose() {
    topicController.clear();
    writeFromController.clear();
    writeToController.clear();
    generatedMailController.clear();
    textToSpeechCtrl.onStopTTS();
    // TODO: implement dispose
    super.dispose();
  }
}

// menyatukan kode
class GeminiEmailApi {
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
