import '../../../config.dart';
import '../../../widgets/app_bar_common_txt_transparant.dart';

class CodeGeneratorScreen extends StatelessWidget {
  final codeGeneratorCtrl = Get.put(CodeGeneratorController());

  CodeGeneratorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CodeGeneratorController>(builder: (_) {
      print(
          "codeGeneratorCtrl.markdownText2 ==> ${codeGeneratorCtrl.markdownText}");
      return WillPopScope(
        onWillPop: () => textToSpeechCtrl.onStopTTS(),
        child: DirectionalityRtl(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: appCtrl.appTheme.bg1,
            // appBar: AppAppBarCommon(
            //     title: appFonts.codeGenerator,
            //     leadingOnTap: () => textToSpeechCtrl.onStopTTS()),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                codeGeneratorCtrl.isCodeGenerate == true
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppAppBarCommonTxtTr(
                              title: appFonts.codeGenerator,
                              leadingOnTap: () => Get.back(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(appFonts.weCreatedIncredible.tr,
                                    style: AppCss.outfitSemiBold16
                                        .textColor(appCtrl.appTheme.primary)),
                                const VSpace(Sizes.s23),
                                // (codeGeneratorCtrl.markdownText != null) ? Markdown(
                                //       data:codeGeneratorCtrl.markdownText, // Gunakan variabel markdownText
                                //       styleSheet: MarkdownStyleSheet(
                                //         // Atur gaya sesuai kebutuhan Anda
                                //         // Contoh pengaturan:
                                //         h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                //         p: TextStyle(fontSize: 16),
                                //       ),
                                //     )
                                //         .paddingSymmetric(horizontal: Insets.i15, vertical: Insets.i20)
                                //         .authBoxExtension() : SizedBox(),

                                InputLayout(
                                    color: appCtrl.appTheme.white,
                                    title: appFonts.generatedCode,
                                    isMax: false,
                                    text: codeGeneratorCtrl.markdownText,
                                    //codeGeneratorCtrl.markdownText, //codeGeneratorCtrl.response,
                                    responseText:
                                        codeGeneratorCtrl.markdownText),
                                // codeGeneratorCtrl.markdownText, ),//codeGeneratorCtrl.response)
                              ],
                            ),
                            const VSpace(Sizes.s30),
                            ButtonCommon(
                              title: appFonts.endCodeGenerator,
                              onTap: () =>
                                  codeGeneratorCtrl.endCodeGeneratorDialog(),
                            )
                          ],
                        ).paddingSymmetric(
                            horizontal: Insets.i20, vertical: Insets.i30),
                      )
                    : CodeGeneratorLayout(),
                if (codeGeneratorCtrl.isCodeGenerate == false)
                  AdCommonLayout(
                      // bannerAd: codeGeneratorCtrl.bannerAd,
                      bannerAdIsLoaded: codeGeneratorCtrl.bannerAdIsLoaded,
                      currentAd: codeGeneratorCtrl.currentAd),
                if (codeGeneratorCtrl.isLoader == true) const LoaderLayout(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
