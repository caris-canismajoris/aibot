//view.dart
import 'package:aibot/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/app_bar_common_transparant.dart';
import '../../widgets/app_bar_common_txt_transparant.dart';
import '../widgets/chat_input_box.dart';
import 'widgets_chat_bot/appBar_Dashboard.dart';
import 'widgets_chat_bot/chat_item.dart';

class ChatBotScreen extends StatefulWidget {
  ChatBotScreen({super.key});
  final chatCtrl = Get.put(ChatLayoutController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;
  final List<Content> chats = [];
  String? chatId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLayoutController>(builder: (context) {
      return DirectionalityRtl(
        child: Scaffold(
          // appBar:
          // AppBar(
          //   leading: SizedBox(),
          // ),
          // ChatScreenAppBar(),

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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween, //Around,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(
                  //           left: Sizes.s16, top: Sizes.s30),
                  //       child: SizedBox(
                  //         height: 15,
                  //         width: 15,
                  //         child: SvgPicture.asset(
                  //                 appCtrl.isRTL || appCtrl.languageVal == "ar"
                  //                     ? eSvgAssets.rightArrow1
                  //                     : eSvgAssets.leftArrow,
                  //                 height: 10,
                  //                 colorFilter: ColorFilter.mode(
                  //                     appCtrl.appTheme.sameWhite,
                  //                     BlendMode.srcIn))
                  //             .inkWell(onTap: () => Get.back()),
                  //       ),
                  //     ),
                  //     // CachedNetworkImageLayout(),
                  //     // AppAppBarCommonTxtTr(
                  //     //   title: "Chat Bot",
                  //     //   leadingOnTap: () => Get.back(),
                  //     // ),
                  //     // Padding(
                  //     //   padding: EdgeInsets.only(top: Sizes.s30),
                  //     //   child: AppAppBarChatBotTr(
                  //     //     title: "",
                  //     //     // title: appFonts.chatBot,
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: Sizes.s36),
                    child: AppAppBarCommonTxtTr(
                          title: "Chat Bot",
                          leadingOnTap: () => Get.back(),
                        ),
                  ).paddingOnly(left: Sizes.s16) ,//Symmetric(horizontal: 16,),
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
                                "characterId": appCtrl.selectedCharacter["id"],
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
                                    ? Get.find<SubscriptionFirebaseController>()
                                    : Get.put(SubscriptionFirebaseController());
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
  }
}
