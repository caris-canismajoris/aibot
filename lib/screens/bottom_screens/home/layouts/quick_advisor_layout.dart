import 'dart:async';

import '../../../../config.dart';
import '../../../../new_features/chat_bot/chatBotScreen.dart';
import '../../../app_screens/email_generator_screen/temp_email_gen/temp_email_gen.dart';

class QuickAdvisorLayout extends StatelessWidget {
  final dynamic data;
  final bool isFavorite;
  final int? selectIndex, index;
  final GestureTapCallback? onTap;

  const QuickAdvisorLayout(
      {Key? key,
      this.data,
      this.selectIndex,
      this.onTap,
      this.index,
      this.isFavorite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
                opacity:  0.85,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Stack(
            alignment: Alignment.center, //bottomCenter,
            children: [
              Stack(
                alignment: Alignment.centerLeft ,//topLeft,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: Sizes.s80 ,//s102,
                    // width: Sizes.s100,
                    decoration: BoxDecoration(
                      color: appCtrl.appTheme.boxBg,
                      border: Border.all(
                        color: appCtrl.appTheme.txt,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        22,
                      ),
                    ),
                    // child: Image.asset(
                    //   eImageAssets.quickAdvisorContainer,
                    //   color: appCtrl.appTheme.boxBg,
                    //   alignment: Alignment.bottomCenter,
                    // ),
                  ),
                  // SizedBox(
                  //         height: Sizes.s45,
                  //         width: Sizes.s45,
                  //         child: SvgPicture.asset(data["icon"],
                  //                 height: Sizes.s24,
                  //                 width: Sizes.s24,
                  //                 fit: BoxFit.scaleDown,
                  //                 colorFilter: ColorFilter.mode(
                  //                     appCtrl.appTheme.sameWhite, BlendMode.srcIn))
                  //             .decorated(
                  //                 color: appCtrl.appTheme.primary,
                  //                 shape: BoxShape.circle))
                  //     .paddingOnly(left: Insets.i10)
                ],
              ),
              SizedBox(
                width: Sizes.s200,
                child: Text(
                  data["title"].toString().tr,
                  textAlign: TextAlign.start,
                  style: AppCss.outfitMedium22.textColor(
                      appCtrl.appTheme.txt), //style: AppCss.outfitMedium14
                ).padding(bottom: Insets.i10, horizontal: Insets.i5),
              ),
            ],
          ).inkWell(
            onTap: () {
              if (data["title"] == appFonts.translateAnything) {
                Get.toNamed(routeName.translateScreen);
              } else if (data["title"] == appFonts.codeGenerator) {
                Get.toNamed(routeName.codeGeneratorScreen);
              } else if (data["title"] == appFonts.emailGenerator) {
                Get.to(TempEmailGeneratorScreen());
                // End(TempEmailGeneratorScreen() as FutureOr Function());
                // Get.toNamed(routeName.emailWriterScreen);
              } else if (data["title"] == appFonts.socialMedia) {
                Get.toNamed(routeName.socialMediaScreen);
              } else if (data["title"] == appFonts.passwordGenerator) {
                Get.toNamed(routeName.passwordGeneratorScreen);
              } else if (data["title"] == appFonts.essayWriter) {
                Get.toNamed(routeName.essayWriterScreen);
              } else if (data["title"] == appFonts.travelHangout) {
                Get.toNamed(routeName.travelScreen);
              } else if (data["title"] == appFonts.personalAdvice) {
                Get.toNamed(routeName.personalAdvisorScreen);
              } else if (data["title"] == appFonts.content1) {
                Get.toNamed(routeName.contentWriterScreen);
              } else {
                Get.to(ChatBotScreen());
                // Get.toNamed(routeName.chatLayout);
                final chatCtrl = Get.isRegistered<ChatLayoutController>()
                    ? Get.find<ChatLayoutController>()
                    : Get.put(
                        ChatLayoutController(),
                      );
                chatCtrl.getChatId();
              }
            },
          ),
          SvgPicture.asset(isFavorite
                  ? eSvgAssets.fillStar
                  : selectIndex != null
                      ? selectIndex == index
                          ? eSvgAssets.fillStar
                          : eSvgAssets.unFillStar
                      : eSvgAssets.unFillStar)
              .inkWell(onTap: onTap)
              .padding(
                bottom: Insets.i20,
                horizontal: Insets.i22, //i8,
              ),
        ],
      ),
    );
  }
}
