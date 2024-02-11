import '../../../config.dart';
import '../../../new_features/controller_new_features/controller_nf.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../config.dart';
import 'widget_code_bot/chat_item_widget.dart';

class CodeBotGeneratorLayout extends StatelessWidget {
  CodeBotGeneratorLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ChatLayoutControllerNF());
    return GetBuilder<ChatLayoutControllerNF>(builder: (codeGeneratorCtrl) {
      print(
          'codeGeneratorCtrl.resultMessageAiCodes ==> ${codeGeneratorCtrl.resultMessageAiCodes}');
      return Scaffold(
        // appBar: const ChatScreenAppBar(),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (codeGeneratorCtrl.resultMessageAiCodes == null)
                ? Container(
                    child: Column(
                      children: [
                        Text(appFonts.typeAnythingTo.tr,
                            style: AppCss.outfitSemiBold16
                                .textColor(appCtrl.appTheme.primary)),
                        const VSpace(Sizes.s15),
                        Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(appFonts.selectLanguage.tr,
                                  style: AppCss.outfitSemiBold14
                                      .textColor(appCtrl.appTheme.txt)),
                              const VSpace(Sizes.s8),
                              SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                              codeGeneratorCtrl.onSelect ??
                                                  "C#",
                                              style: AppCss.outfitMedium16
                                                  .textColor(
                                                      appCtrl.appTheme.txt))
                                          .paddingAll(Insets.i15)
                                          .decorated(
                                              color: appCtrl.appTheme.textField,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          AppRadius.r8))))
                                  .inkWell(
                                      onTap: () => codeGeneratorCtrl
                                          .onSelectLanguageSheet()),
                              const VSpace(Sizes.s28),
                              InputLayout(
                                  title: appFonts.writeStuff,
                                  isMax: true,
                                  microPhoneTap: () {
                                    Vibration.vibrate(duration: 200);
                                    codeGeneratorCtrl.speechToText();
                                  },
                                  isAnimated:
                                      codeGeneratorCtrl.isListening.value,
                                  height: codeGeneratorCtrl.isListening.value
                                      ? codeGeneratorCtrl.animation!.value
                                      : Sizes.s20,
                                  controller: codeGeneratorCtrl.codeController,
                                  onTap: () =>
                                      codeGeneratorCtrl.codeController.clear())
                            ])
                            .paddingSymmetric(
                                horizontal: Insets.i15, vertical: Insets.i20)
                            .authBoxExtension(),
                        const VSpace(Sizes.s40),
                      ],
                    ),
                  )
                : Container( 
                  child: Text("HASIL GENERATE", style: TextStyle(fontSize: 22,),),
                ),

            if (codeGeneratorCtrl.resultMessageAiCodes != null)
              ResultWidget(
                resultMessageAiCodes: codeGeneratorCtrl.resultMessageAiCodes!,
              ),

            (codeGeneratorCtrl.resultMessageAiCodes == null)
                ? ButtonCommon(
                    title: appFonts.createMagicalCode,
                    onTap: () => codeGeneratorCtrl.onCodeGenerate(),
                  )
                : ButtonCommon(
                    title: "REFRESH",
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CodeBotGeneratorLayout(),
                      ),
                    ),
                  ),
            // tampilkan disini
            //menggunakan MarkDown!
          ],
        ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30),
      );
    });
  }
}
