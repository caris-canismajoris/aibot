//view.dart
import 'package:aibot/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';


class ChatBotScreens extends StatefulWidget {
  ChatBotScreens({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<ChatBotScreens> createState() => _ChatBotScreensState();
}

class _ChatBotScreensState extends State<ChatBotScreens> {
  final chatCtrl = Get.put(ChatLayoutController());
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  bool _loading = false;
  final List<Content> chats = [];
  String? chatId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLayoutController>(builder: (_) {
      return CommonStream(
        child: GetBuilder<AppController>(
          builder: (appCtrl) {
            return DirectionalityRtl(
              child: WillPopScope(
                onWillPop: () async {
                  chatCtrl.speechStopMethod();
                  chatCtrl.clearData();
                  return true;
                },
                child: Screenshot(
                  controller: chatCtrl.screenshotController,
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    key: chatCtrl.scaffoldKey,
                    drawer: const CommonDrawer(),
                    backgroundColor: appCtrl.appTheme.bg1,
                    appBar: const ChatScreenAppBar(),
                    body: InkWell(
                      onTap: () {
                        chatCtrl.isLongPress = false;
                        chatCtrl.selectedData = [];
                        chatCtrl.selectedIndex = [];
                        chatCtrl.update();
                      },
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: Column(children: [
                          const VSpace(Sizes.s10),
                          AdCommonLayout(
                              //   bannerAd: chatCtrl.bannerAd,
                              bannerAdIsLoaded: chatCtrl.bannerAdIsLoaded,
                              currentAd: chatCtrl.currentAd),
                          Text("Today, ${DateFormat("hh:mm a").format(DateTime.now())}",
                                  style: AppCss.outfitMedium14
                                      .textColor(appCtrl.appTheme.txt))
                              .marginOnly(top: Insets.i5),
                          const VSpace(Sizes.s13),
                          const Expanded(flex: 5, child: ChatList()),
                          Container(),
                          const Expanded(flex: 0, child: ChatTextBox())
                        ]).chatBgExtension(
                          chatCtrl.selectedImage,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
