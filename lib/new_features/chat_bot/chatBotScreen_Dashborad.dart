// //view.dart
// import 'package:aibot/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:lottie/lottie.dart';

// import '../widgets/chat_input_box.dart';
// import 'widgets_chat_bot/chat_item.dart';

// class ChatBotScreenDashBoard extends StatefulWidget {
//   ChatBotScreenDashBoard({super.key});
//   final chatCtrl = Get.put(ChatLayoutController());
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   State<ChatBotScreenDashBoard> createState() => _ChatBotScreenDashBoardState();
// }

// class _ChatBotScreenDashBoardState extends State<ChatBotScreenDashBoard> {
//   final controller = TextEditingController();
//   final gemini = Gemini.instance;
//   bool _loading = false;
//   final List<Content> chats = [];
//   String? chatId;

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ChatLayoutController>(builder: (context) {
//       return DirectionalityRtl(
//         child: Scaffold(
//           // // AppBar(
//           // //   leading: SizedBox(),
//           // // ),
//           // backgroundColor: Colors.transparent,
//           appBar: const ChatScreenAppBar(
//             // backgroundColor: Colors.transparent,
//             leading: SizedBox(),
//           ),
//           body: Stack(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/backgroundwp/bgwp1.png'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Column(
//                 children: [
//                   Expanded(
//                     child: chats.isNotEmpty
//                         ? Align(
//                             alignment: Alignment.bottomCenter,
//                             child: SingleChildScrollView(
//                               reverse: true,
//                               child: ListView.builder(
//                                 itemBuilder: (context, index) =>
//                                     ChatItemWidget(content: chats[index]),
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: chats.length,
//                                 reverse: false,
//                               ),
//                             ),
//                           )
//                         : const Center(child: Text('Tanyakan sesuatu!')),
//                   ),
//                   if (_loading) Lottie.asset('assets/lottie/ai.json'),
//                   ChatInputBox(
//                     controller: controller,
//                     onSend: () async {
//                       if (controller.text.isNotEmpty) {
//                         final searchedText = controller.text;
//                         chats.add(Content(
//                             role: 'user', parts: [Parts(text: searchedText)]));
//                         controller.clear();
//                         _loading = true;

//                         bool isGuestLogin =
//                             appCtrl.storage.read(session.isGuestLogin);

//                         // Simpan pesan pengguna ke Firebase Firestore
//                         if (!isGuestLogin) {
//                           final user = FirebaseAuth.instance.currentUser;
//                           if (user != null) {
//                             await FirebaseFirestore.instance
//                                 .collection("users")
//                                 .doc(user.uid)
//                                 .collection("chats")
//                                 .add({
//                               'userId': user.uid,
//                               'avatar': appCtrl.selectedCharacter["image"],
//                               "characterId": appCtrl.selectedCharacter["id"],
//                               'message': searchedText,
//                               'chatId': chatId,
//                               "createdDate":
//                                   DateTime.now().millisecondsSinceEpoch,
//                             });
//                           }
//                         }

//                         gemini.streamChat(chats).listen((value) {
//                           print("-------------------------------");
//                           print(value.output);
//                           _loading = false;
//                           setState(() {
//                             if (chats.isNotEmpty &&
//                                 chats.last.role == value.content?.role) {
//                               chats.last.parts!.last.text =
//                                   '${chats.last.parts!.last.text}${value.output}';
//                             } else {
//                               chats.add(Content(
//                                   role: 'model',
//                                   parts: [Parts(text: value.output)]));
//                               // Menggunakan metode dari SubscriptionFirebaseController
//                               final firebaseCtrl = Get.isRegistered<
//                                       SubscriptionFirebaseController>()
//                                   ? Get.find<SubscriptionFirebaseController>()
//                                   : Get.put(SubscriptionFirebaseController());
//                               firebaseCtrl.removeBalance();
//                               firebaseCtrl.update();
//                             }
//                           });
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

//view.dart
import 'package:aibot/config.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';

import '../../screens/bottom_screens/home/layouts/top_appBar.dart';
import '../../widgets/app_bar_common_transparant.dart';
import '../widgets/chat_input_box.dart';
import 'widgets_chat_bot/appBar_Dashboard.dart';
import 'widgets_chat_bot/chat_item.dart';

class ChatBotScreenDashBoard extends StatefulWidget {
  ChatBotScreenDashBoard({super.key});
  final chatCtrl = Get.put(ChatLayoutController());
  final homeCtrl = Get.put(HomeController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<ChatBotScreenDashBoard> createState() => _ChatBotScreenDashBoardState();
}

class _ChatBotScreenDashBoardState extends State<ChatBotScreenDashBoard> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;
  final List<Content> chats = [];
  String? chatId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeCtrl) {
      return GetBuilder<ChatLayoutController>(builder: (context) {
        return DirectionalityRtl(
          child: Scaffold(
            // appBar:
            // AppBar(
            //   backgroundColor: Colors.transparent,
            //   leading: const SizedBox(),
            //   actions: const [
            //     CommonBalance(),
            //     SizedBox(
            //       width: 12,
            //     )
            //   ],
            // ),

            // const  ChatScreenAppBarDashBoard(
            // leading: SizedBox(),
            // ),

            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundwp/bgwp1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: Sizes.s30 ),
                      child: AppAppBarChatBotTr(
                        title: "",
                      ),
                    ),
                    Expanded(
                      child: chats.isNotEmpty
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: SingleChildScrollView(
                                reverse: true,
                                child: ListView.builder(
                                  itemBuilder: (context, index) =>
                                      ChatItemWidget(content: chats[index]),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: chats.length,
                                  reverse: false,
                                ),
                              ),
                            )
                          : const Center(child: Text('Tanyakan sesuatu!')),
                    ),
                    if (_loading) Lottie.asset('assets/lottie/ai.json'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: ChatInputBox(
                        controller: controller,
                        onSend: () async {
                          if (controller.text.isNotEmpty) {
                            final searchedText = controller.text;
                            chats.add(Content(
                                role: 'user',
                                parts: [Parts(text: searchedText)]));
                            controller.clear();
                            _loading = true;

                            bool isGuestLogin =
                                appCtrl.storage.read(session.isGuestLogin);

                            // Simpan pesan pengguna ke Firebase Firestore
                            if (!isGuestLogin) {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .collection("chats")
                                    .add({
                                  'userId': user.uid,
                                  'avatar': appCtrl.selectedCharacter["image"],
                                  "characterId":
                                      appCtrl.selectedCharacter["id"],
                                  'message': searchedText,
                                  'chatId': chatId,
                                  "createdDate":
                                      DateTime.now().millisecondsSinceEpoch,
                                });
                              }
                            }

                            gemini.streamChat(chats).listen((value) {
                              print("-------------------------------");
                              print(value.output);
                              _loading = false;
                              setState(() {
                                if (chats.isNotEmpty &&
                                    chats.last.role == value.content?.role) {
                                  chats.last.parts!.last.text =
                                      '${chats.last.parts!.last.text}${value.output}';
                                } else {
                                  chats.add(Content(
                                      role: 'model',
                                      parts: [Parts(text: value.output)]));
                                  // Menggunakan metode dari SubscriptionFirebaseController
                                  final firebaseCtrl = Get.isRegistered<
                                          SubscriptionFirebaseController>()
                                      ? Get.find<
                                          SubscriptionFirebaseController>()
                                      : Get.put(
                                          SubscriptionFirebaseController());
                                  firebaseCtrl.removeBalance();
                                  firebaseCtrl.update();
                                }
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
