import '../../../../config.dart';
import '../../../../new_features/code_bot/widget_code_bot/chat_item_widget.dart';
import '../temp_essay/temp_essay_controller.dart';

class TempEssayWriterScreen extends StatelessWidget {
  const TempEssayWriterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EssayWriterControllerTemp);
    return GetBuilder<EssayWriterControllerTemp>(builder: (essayWriterCtrl) {
      return Column(children: [
        // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //   textCommon.outfitSemiBoldPrimary16(text: appFonts.getAnExceptional),
        //   const VSpace(Sizes.s15),
        //   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //     InputLayout(
        //         hintText: appFonts.writeTheEssay,
        //         title: appFonts.subjectOfTheEssay,
        //         isMax: true,
        //         isAnimated: essayWriterCtrl.isListening.value,
        //         height: essayWriterCtrl.isListening.value
        //             ? essayWriterCtrl.animation!.value
        //             : Sizes.s20,
        //         microPhoneTap: () {
        //           Vibration.vibrate(duration: 200);
        //           essayWriterCtrl.speechToText();
        //         },
        //         controller: essayWriterCtrl.essayController,
        //         onTap: () => essayWriterCtrl.essayController.clear()),
        //     const VSpace(Sizes.s20),
        //     textCommon.outfitSemiBoldTxt14(text: appFonts.essayType),
        //     const VSpace(Sizes.s10),
        //     Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: essayWriterCtrl.essayTypeLists
        //             .asMap()
        //             .entries
        //             .map((e) => PasswordRadioButtonLayout(
        //                 data: e.value,
        //                 index: e.key,
        //                 selectIndex: essayWriterCtrl.selectedIndex,
        //                 onTap: () => essayWriterCtrl.onEssayTypeChange(e.key)))
        //             .toList())
        //   ])
        //       .paddingSymmetric(vertical: Insets.i20, horizontal: Insets.i15)
        //       .authBoxExtension()
        // ]),
        // const VSpace(Sizes.s30),
        // if (essayWriterCtrl.resultMessageAiCodes != null)
        //   ResultWidget(
        //     resultMessageAiCodes: essayWriterCtrl.resultMessageAiCodes!,
        //   ),
        // const VSpace(Sizes.s40),
        // (essayWriterCtrl.resultMessageAiCodes == null)
        //     ? ButtonCommon(
        //         title: appFonts.startEssayWriting,
        //         onTap: () => essayWriterCtrl.onEssayGenerated())
        //     : ButtonCommon(
        //         title: "RESET", // Ubah teks tombol menjadi "RESET"
        //         onTap: () {
        //           essayWriterCtrl.resetCodeData(); // Panggil fungsi resetData
        //           // Navigasi ke halaman yang sama (refresh halaman)
        //           // Navigator.of(context).pushReplacement(
        //           //   MaterialPageRoute(
        //           //     builder: (context) => CodeGeneratorLayout(),
        //           //   ),
        //           // );
        //         },
        //       ),
        // const VSpace(Sizes.s30),
        // const AdCommonLayout().backgroundColor(appCtrl.appTheme.error),
      ]).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30);
    });
  }
}
