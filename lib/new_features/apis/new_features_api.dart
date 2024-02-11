import 'dart:async';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../../config.dart';

class ApiServices {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  // Stream untuk mendengarkan perubahan nilai
  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Content>> processGeminiStream(List<Content> chats,
      {List<Map<String, String>>? conversationHistory}) async {
    bool isLocalChatApi = appCtrl.storage.read(session.isGeminiKey) ?? false;

    if (isLocalChatApi == false) {
      final firebaseCtrl = Get.isRegistered<SubscriptionFirebaseController>()
          ? Get.find<SubscriptionFirebaseController>()
          : Get.put(SubscriptionFirebaseController());
      firebaseCtrl.removeBalance();
    }

    List<Map<String, String>> currentConversationHistory =
        conversationHistory ?? [];

    gemini.streamChat(chats).listen((value) {
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

    return modelOutput;
  }

  // Fungsi untuk mendapatkan list chats
  List<Content> getChats() {
    return modelOutput;
  }
}
