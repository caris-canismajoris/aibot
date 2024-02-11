// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:aibot/config.dart';

class ApiServices {
  static var client = http.Client();
  static List<Map<String, String>> conversationHistory = [];

  static Future<String> chatCompeletionResponse(String prompt,
      {addApiKey}) async {
    bool isLocalChatApi = appCtrl.storage.read(session.isChatGPTKey) ?? false;
    if (isLocalChatApi == false || addApiKey == null) {
      final firebaseCtrl = Get.isRegistered<SubscriptionFirebaseController>()
          ? Get.find<SubscriptionFirebaseController>()
          : Get.put(SubscriptionFirebaseController());
      firebaseCtrl.removeBalance();
    }
    var url = Uri.https("api.openai.com", "/v1/chat/completions");
    log("prompt : $prompt");

    conversationHistory.add({"role": "user", "content": prompt});

    String localApi = appCtrl.storage.read(session.chatGPTKey) ?? "";
    log("API: $localApi");
    String apiKey = appCtrl.firebaseConfigModel!
        .chatGPTKey!; //"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";
    if (addApiKey != null) {
      apiKey = addApiKey;
      print("apiKey3 ==> $apiKey");
    } else {
      if (localApi == "") {
        apiKey = appCtrl.firebaseConfigModel!.chatGPTKey!;
        print("apiKey2 ==> $apiKey");
      } else {
        apiKey = localApi;
        print("apiKey3 ==> $apiKey");
      }
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
        "messages": conversationHistory
      }),
    );

    // Do something with the response
    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));

    log("RES $newresponse");

    if (response.statusCode == 200) {
      conversationHistory.add({
        "role": "assistant",
        "content": newresponse['choices'][0]['message']['content']
      });

      return response.statusCode == 200
          ? newresponse['choices'][0]['message']['content']
          : "";
    } else {
      return "";
    }
  }
}

// ================================================ //

class GeminiChatStreamApiServices {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  // Stream untuk mendengarkan perubahan nilai
  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Content>> chatCompeletionResponse(List<Content> chats,
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

// ================================================ //

class GeminiChatApiServices {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Content>> chatCompeletionResponse(List<Content> chats,
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

    var requestBody = {
      "messages": currentConversationHistory,
    };

    final response = await http.post(
      Uri.parse(
          "URL_API_GEMINI_DISINI"), // Ganti dengan URL API Gemini yang sesuai
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer TOKEN_GEMINI_DISINI', // Ganti dengan token Gemini yang sesuai
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      List<dynamic> geminiResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      String geminiOutput = geminiResponse[0]['content'];
      chats.add(
        Content(
          role: 'model',
          parts: [
            Parts(text: geminiOutput),
          ],
        ),
      );

      _modelOutputController.add(chats);
    }

    return chats;
  }

  List<Content> getChats() {
    return modelOutput;
  }
}

// gemini api gemini //

class GeminiChatApi {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Map<String, String>>> chatCompeletionResponse(List<Content> chats,
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

    return currentConversationHistory;
  }
}


//code generator
class GeminiCodeApi {
  final gemini = Gemini.instance;
  final List<Content> modelOutput = [];
  final _modelOutputController = StreamController<List<Content>>.broadcast();

  Stream<List<Content>> get onModelOutputChange =>
      _modelOutputController.stream;

  Future<List<Map<String, String>>> chatCompletionResponse(List<Content> chats,
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
