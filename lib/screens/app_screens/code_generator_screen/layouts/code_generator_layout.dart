// import 'package:flutter_markdown/flutter_markdown.dart';

// import '../../../../config.dart';

// class CodeGeneratorLayout extends StatelessWidget {
//   CodeGeneratorLayout({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     Get.put(CodeGeneratorController());
//     return GetBuilder<CodeGeneratorController>(builder: (codeGeneratorCtrl) {
//       return ListView(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(appFonts.typeAnythingTo.tr,
//               style:
//                   AppCss.outfitSemiBold16.textColor(appCtrl.appTheme.primary)),
//           const VSpace(Sizes.s15),
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(appFonts.selectLanguage.tr,
//                 style: AppCss.outfitSemiBold14.textColor(appCtrl.appTheme.txt)),
//             const VSpace(Sizes.s8),
//             SizedBox(
//                     width: double.infinity,
//                     child: Text(codeGeneratorCtrl.onSelect ?? "C#",
//                             style: AppCss.outfitMedium16
//                                 .textColor(appCtrl.appTheme.txt))
//                         .paddingAll(Insets.i15)
//                         .decorated(
//                             color: appCtrl.appTheme.textField,
//                             borderRadius: const BorderRadius.all(
//                                 Radius.circular(AppRadius.r8))))
//                 .inkWell(
//                     onTap: () => codeGeneratorCtrl.onSelectLanguageSheet()),
//             const VSpace(Sizes.s28),
//             InputLayout(
//                 title: appFonts.writeStuff,
//                 isMax: true,
//                 microPhoneTap: () {
//                   Vibration.vibrate(duration: 200);
//                   codeGeneratorCtrl.speechToText();
//                 },
//                 isAnimated: codeGeneratorCtrl.isListening.value,
//                 height: codeGeneratorCtrl.isListening.value
//                     ? codeGeneratorCtrl.animation!.value
//                     : Sizes.s20,
//                 controller: codeGeneratorCtrl.codeController,
//                 onTap: () => codeGeneratorCtrl.codeController.clear())
//           ])
//               .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i20)
//               .authBoxExtension(),
//           const VSpace(Sizes.s40),

//       // (codeGeneratorCtrl.markdownText != null) ? Markdown(
//       //       data:codeGeneratorCtrl.markdownText, // Gunakan variabel markdownText
//       //       styleSheet: MarkdownStyleSheet(
//       //         // Atur gaya sesuai kebutuhan Anda
//       //         // Contoh pengaturan:
//       //         h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       //         p: TextStyle(fontSize: 16),
//       //       ),
//       //     )
//       //         .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i20)
//       //         .authBoxExtension() : SizedBox(),

//           // ButtonCommon(
//           //   title: appFonts.createMagicalCode,
//           //   onTap: () => codeGeneratorCtrl.onCodeGenerate(),
//           // ),

//           (codeGeneratorCtrl.resultMessageAiCodes == null)
//                 ? ButtonCommon(
//                     title: appFonts.createMagicalCode,
//                     onTap: () => codeGeneratorCtrl.onCodeGenerate(),
//                   )
//                 : ButtonCommon(
//                     title: "REFRESH",
//                     onTap: () => Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => CodeGeneratorLayout(),
//                       ),
//                     ),
//                   ),

//           // tampilkan disini
//           //menggunakan MarkDown!
//         ],
//       ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30);
//     });
//   }
// }

import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../config.dart';
import '../../../../new_features/code_bot/widget_code_bot/chat_item_widget.dart';
import '../../../../widgets/app_bar_common_txt_transparant.dart';
import '../temp_controller/temp_controller.dart';

class CodeGeneratorLayout extends StatelessWidget {
  CodeGeneratorLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(TempCodeGeneratorController());
    return GetBuilder<TempCodeGeneratorController>(
        builder: (codeGeneratorCtrl) {
      return Stack(
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAppBarCommonTxtTr(
                title: appFonts.codeGenerator,
                leadingOnTap: () => Get.back(),
              ),
              (codeGeneratorCtrl.resultMessageAiCodes == null)
                  ? Container(
                      child: Column(
                        children: [
                          Text(appFonts.typeAnythingTo.tr,
                              style: AppCss.outfitSemiBold16
                                  .textColor(appCtrl.appTheme.primary)),
                          const VSpace(Sizes.s15),
                          Opacity(
                            opacity: 0.75,
                            child:
                                Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                  Text(appFonts.selectLanguage.tr,
                                      style: AppCss.outfitSemiBold14
                                          .textColor(appCtrl.appTheme.txt)),
                                  const VSpace(Sizes.s8),
                                  SizedBox(
                                          width: double.infinity,
                                          child: Text(codeGeneratorCtrl.onSelect ?? "C#",
                                                  style: AppCss.outfitMedium16
                                                      .textColor(
                                                          appCtrl.appTheme.txt))
                                              .paddingAll(Insets.i15)
                                              .decorated(
                                                  color: appCtrl
                                                      .appTheme.textField,
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
                                      height: codeGeneratorCtrl
                                              .isListening.value
                                          ? codeGeneratorCtrl.animation!.value
                                          : Sizes.s20,
                                      controller:
                                          codeGeneratorCtrl.codeController,
                                      onTap: () => codeGeneratorCtrl
                                          .codeController
                                          .clear())
                                ])
                                    .paddingSymmetric(
                                        horizontal: Insets.i15,
                                        vertical: Insets.i20)
                                    .authBoxExtension(),
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      "HASIL GENERATE",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
              const VSpace(Sizes.s20),
              if (codeGeneratorCtrl.resultMessageAiCodes != null)
                Opacity(
                  opacity: 0.9 ,
                  child: ResultWidget(
                    resultMessageAiCodes: codeGeneratorCtrl.resultMessageAiCodes!,
                  ),
                ),
              const SizedBox(
                height: 22,
              ),
              (codeGeneratorCtrl.resultMessageAiCodes == null)
                  ? ButtonCommon(
                      title: appFonts.createMagicalCode,
                      onTap: () => codeGeneratorCtrl.onCodeGenerate(),
                    )
                  : ButtonCommon(
                      title: "RESET", // Ubah teks tombol menjadi "RESET"
                      onTap: () {
                        codeGeneratorCtrl
                            .resetCodeData(); // Panggil fungsi resetData
                        // Navigasi ke halaman yang sama (refresh halaman)
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => CodeGeneratorLayout(),
                        //   ),
                        // );
                      },
                    ),
              const SizedBox(
                height: 22,
              ),
              // if (codeGeneratorCtrl.resultMessageAiCodes != null)
              //   ButtonCommon(
              //     title: appFonts.endCodeGenerator,
              //     onTap: () => codeGeneratorCtrl.endCodeGeneratorDialog(),
              //   ),
            ],
          ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i30),
        ],
      );
    });
  }
}
