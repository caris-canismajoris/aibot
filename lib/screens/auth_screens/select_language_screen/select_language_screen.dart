import 'package:flutter/services.dart';
import '../../../config.dart';
import 'layouts/select_lang_button.dart';

class SelectLanguageScreen extends StatelessWidget {
  final languageCtrl = Get.put(SelectLanguageController());

  SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLanguageController>(
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            if (languageCtrl.isBack) {
              Get.back();
            } else {
              SystemNavigator.pop();
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: appCtrl.appTheme.bg1,
            // appBar:  AppBarCommon(isSystemNavigate: languageCtrl.isBack ? true: false),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgroundwp/bgwp5.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(appFonts.selectLanguage.tr,
                              style: AppCss.outfitSemiBold22
                                  .textColor(appCtrl.appTheme.txt)),
                          const VSpace(Sizes.s10),
                          Text(appFonts.youCanChangeIt.tr,
                              style: AppCss.outfitMedium16
                                  .textColor(appCtrl.appTheme.lightText)),
                          const DottedLines().paddingOnly(top: Insets.i20),
                          ...languageCtrl.selectLanguageLists
                              .asMap()
                              .entries
                              .map(
                                (e) => RadioButtonLayout(
                                  data: e.value,
                                  selectIndex: languageCtrl.selectIndex,
                                  index: e.key,
                                  onTap: () async {
                                    languageCtrl.selectIndex = e.key;
                                    if (e.value.code == "en") {
                                      appCtrl.languageVal = "en";
                                    } else if (e.value.code == "hi") {
                                      appCtrl.languageVal = "hi";
                                    } else if (e.value.code == "ar") {
                                      appCtrl.languageVal = "ar";
                                    } else if (e.value.code == "fr") {
                                      appCtrl.languageVal = "fr";
                                    } else if (e.value.code == "it") {
                                      appCtrl.languageVal = "it";
                                    } else if (e.value.code == "ge") {
                                      appCtrl.languageVal = "ge";
                                    }

                                    appCtrl.update();
                                    await appCtrl.storage.write(
                                        "index", languageCtrl.selectIndex);
                                    await appCtrl.storage
                                        .write("locale", e.value.code);

                                    languageCtrl.update();
                                    appCtrl.update();
                                    Get.updateLocale(e.value.locale);
                                    Get.forceAppUpdate();
                                  },
                                ),
                              )
                              .toList(),
                        ],
                      )
                          .paddingSymmetric(
                              horizontal: Insets.i20, vertical: Insets.i25)
                          .authBoxExtension(),
                      SelectLangButtonCommon(
                        widthBorder: 4,
                        radius: 12,
                        color: Colors.transparent,
                        borderColor: appCtrl.appTheme.txt,
                        title: appFonts.continues,
                        onTap: () => languageCtrl.onContinue(),
                      ).paddingSymmetric(vertical: Insets.i20),
                    ],
                  ).paddingSymmetric(
                    horizontal: Insets.i20,
                    vertical: Insets.i15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

///
///import 'package:flutter/services.dart';

///