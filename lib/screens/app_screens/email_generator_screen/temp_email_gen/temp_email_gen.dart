import '../../../../config.dart';
import '../../../../widgets/app_bar_common_txt_transparant.dart';
import 'temp_email_gen_controller.dart';
import 'temp_widgets/email_markdown.dart';

class TempEmailGeneratorScreen extends StatelessWidget {
  const TempEmailGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TempEmailGeneratorController());
    return GetBuilder<TempEmailGeneratorController>(
        builder: (emailGeneratorCtrl) {
      return Scaffold(
        // appBar: AppAppBarCommon(
        //     title: "Email Generator", leadingOnTap: () => Get.back()
        //     // {
        //     // => emailGeneratorCtrl.onStopTTS()
        //     // },
        //     ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroundwp/bgwp2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     AppAppBarCommonTxtTr(
                      title: "Email Generator",
                      leadingOnTap: () => Get.back(),
                    ),
                    textCommon.outfitSemiBoldPrimary16(
                        text: appFonts.toGetTheExcellent.tr),
                    const VSpace(Sizes.s15),
                    Opacity(
                      opacity: 0.75,
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EmailGeneratorTopLayout(
                                fTitle: appFonts.writeFrom,
                                fHint: appFonts.enterValue,
                                fController:
                                    emailGeneratorCtrl.writeFromController,
                                sTitle: appFonts.writeTo,
                                sHint: appFonts.enterValue,
                                sController:
                                    emailGeneratorCtrl.writeToController),
                            const VSpace(Sizes.s20),
                            textCommon.outfitSemiBoldTxt14(
                                text: appFonts.topic.tr),
                            const VSpace(Sizes.s10),
                            TextFieldCommon(
                                controller: emailGeneratorCtrl.topicController,
                                hintText: appFonts.typeHere,
                                minLines: 8,
                                maxLines: 8,
                                fillColor: appCtrl.appTheme.textField,
                                keyboardType: TextInputType.multiline),
                            const VSpace(Sizes.s20),
                            textCommon.outfitSemiBoldTxt14(
                                text: appFonts.tone.tr),
                            Wrap(
                                children: emailGeneratorCtrl.toneLists
                                    .asMap()
                                    .entries
                                    .map((e) => ToneLayout(
                                        title: e.value,
                                        index: e.key,
                                        selectedIndex:
                                            emailGeneratorCtrl.selectIndex,
                                        onTap: () => emailGeneratorCtrl
                                            .onToneChange(e.key)).paddingOnly(
                                        top: Insets.i10, right: Insets.i10))
                                    .toList()),
                            const VSpace(Sizes.s20),
                            textCommon.outfitSemiBoldTxt14(
                                text: appFonts.mailLength.tr),
                            const VSpace(Sizes.s20),
                            const SliderLayout(),
                            const VSpace(Sizes.s20),
                            const MailLengthLayout()
                          ],
                        ),
                      )
                          .paddingSymmetric(
                              horizontal: Insets.i15, vertical: Insets.i20)
                          .authBoxExtension(),
                    ),
                    const VSpace(Sizes.s20),
                    (emailGeneratorCtrl.resultMessageAiemail != null)
                        ? ResultEmailWidget(
                            resultMessageAiEmail:
                                emailGeneratorCtrl.resultMessageAiemail!,
                          )
                        : const SizedBox(),
                    const VSpace(Sizes.s20),
                  ],
                ),
                const VSpace(Sizes.s30),
                (emailGeneratorCtrl.resultMessageAiemail == null)
                    ? ButtonCommon(
                        title: appFonts.myFitnessMail,
                        onTap: () => emailGeneratorCtrl.onGenerateMail(),
                      )
                    : ButtonCommon(
                        title: "RESET",
                        onTap: () {
                          emailGeneratorCtrl.resultMessageAiemail = null;
                          emailGeneratorCtrl.markdownText = null;
                          emailGeneratorCtrl.topicController.clear();
                          emailGeneratorCtrl.writeFromController.clear();
                          emailGeneratorCtrl.writeToController.clear();
                          emailGeneratorCtrl.generatedMailController.clear();
                          emailGeneratorCtrl.resetEmailData();
                          Get.toEnd(() => Home());
                        }),
                // ButtonCommon(
                //   title: appFonts.myFitnessMail,
                //   onTap: () => emailGeneratorCtrl.onGenerateMail(),
                // ),
              ],
            ).paddingSymmetric(vertical: Insets.i30, horizontal: Insets.i20),
          ],
        ),
      );
    });
  }
}
